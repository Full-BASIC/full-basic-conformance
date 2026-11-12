#!/usr/bin/env python3
"""FBCS runner: executes the programs under programs/ with any BASIC interpreter.

Usage:
  run_suite.py --interpreter 'fullbasic {file}' [--programs DIR] [--output FILE]
               [--name LABEL] [--interpreter-commit C] [--interpreter-version V] [--timeout SECONDS] [--jobs N] [--only ID ...]
               [--reject-codes FILE]

The interpreter template is split with shell rules; {file} is replaced by the
program file name and {drawlog} (optional) by the file where the interpreter must
write its graphic primitives. Each program runs in its own EMPTY temporary
directory (cwd), with the program copied in as <ID>.BAS. A template without
{drawlog} cannot run GRAPHIC tests: they are reported as "unsupported", which
never counts as a failure of the runner but is not a pass either.

Test types (see README.md): SELF, OUTPUT, REJECT, FATAL, WARN, INPUT, GRAPHIC.
When --output is given, the results file also records the git commit, the UTC
date and the platform of the run, so the published results identify the exact
code that was tested.
Exit code: 0 when no test failed (unsupported tests are not failures), 1 otherwise.
"""
import argparse
import json
import os
import platform
import re
import shlex
import shutil
import subprocess
import sys
import tempfile
from concurrent.futures import ThreadPoolExecutor

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import fbcs

PASSED = '*** TEST PASSED ***'
FAILED = '*** TEST FAILED'


def norm(text):
    """Strip trailing blanks on each line and trailing empty lines."""
    return '\n'.join(l.rstrip() for l in text.replace('\r\n', '\n').split('\n')).rstrip('\n')


def _word(n, text):
    return re.search(r'(?<![\w.])' + re.escape(str(n)) + r'(?![\w.])', text) is not None


def _diag(token, text):
    return re.search(r'(?<![\w-])' + re.escape(token) + r'(?![\w-])', text) is not None


def load_reject_codes(path):
    """JSON object {program id: diagnostic token} for one interpreter (see README)."""
    with open(path, encoding='utf-8') as f:
        data = json.load(f)
    if not isinstance(data, dict) or not all(isinstance(k, str) and isinstance(v, str) and v for k, v in data.items()):
        raise SystemExit(f'{path}: expected a JSON object {{program id: non-empty diagnostic}}')
    return data


def evaluate(ttype, hdr, source, run, oracle_out=None, oracle_draw=None, drawlog=None, expect_reject=None):
    """Decide pass/fail. `run` is a dict(rc, stdout, stderr, timeout).
    `expect_reject`: diagnostic the interpreter must report for a REJECT program (None = any).
    Returns (status, detail) with status in pass/fail/unsupported."""
    rc, out, err = run['rc'], run['stdout'], run['stderr']
    if run['timeout']:
        return 'fail', 'timeout'
    lines = [l.strip() for l in out.splitlines()]
    if ttype in ('SELF', 'INPUT') and oracle_out is None:
        if any(l.startswith(FAILED) for l in lines):
            return 'fail', 'program printed *** TEST FAILED'
        if PASSED not in lines:
            return 'fail', 'no *** TEST PASSED *** line'
        if rc != 0:
            return 'fail', f'exit code {rc}'
        return 'pass', ''
    if ttype in ('OUTPUT', 'INPUT'):
        if oracle_out is None:
            return 'fail', 'missing .OUT oracle'
        if rc != 0:
            return 'fail', f'exit code {rc}'
        if norm(out) != norm(oracle_out):
            return 'fail', 'output differs from .OUT'
        return 'pass', ''
    if ttype == 'REJECT':
        if 'EXECUTED' in out:
            return 'fail', 'program was executed (EXECUTED printed)'
        if rc == 0:
            return 'fail', 'program was accepted (exit code 0)'
        if expect_reject is not None and not _diag(expect_reject, out + '\n' + err):
            return 'fail', f'rejected, but not with the expected diagnostic {expect_reject!r}'
        return 'pass', ''
    if ttype in ('FATAL', 'WARN'):
        exp = (hdr.get('EXPECT') or '').split()
        if len(exp) != 2 or not all(x.isdigit() for x in exp):
            return 'fail', 'bad or missing EXPECT <code> <line> header'
        combined = out + '\n' + err
        if ttype == 'FATAL' and rc == 0:
            return 'fail', 'expected a fatal error, exit code 0'
        if ttype == 'WARN' and rc != 0:
            return 'fail', f'warning test must continue and exit 0, exit code {rc}'
        if not _word(exp[0], combined):
            return 'fail', f'exception code {exp[0]} not reported'
        if not _word(exp[1], combined):
            return 'fail', f'line number {exp[1]} not reported'
        return 'pass', ''
    if ttype == 'GRAPHIC':
        if drawlog is None:
            return 'unsupported', 'interpreter template has no {drawlog}'
        if oracle_draw is None:
            return 'fail', 'missing .DRAW oracle'
        if rc != 0:
            return 'fail', f'exit code {rc}'
        if norm(drawlog) != norm(oracle_draw):
            return 'fail', 'primitives differ from .DRAW'
        return 'pass', ''
    return 'fail', f'unknown TYPE {ttype!r}'


def _read(path):
    with open(path, encoding='utf-8', errors='replace', newline='') as f:
        return f.read()


def run_one(pid, path, template, timeout, reject_codes=None):
    source = _read(path)
    hdr = fbcs.parse_header(source)
    ttype = (hdr.get('TYPE') or '').upper()
    side = fbcs.sidecars(path)
    oracle_out = _read(side['.OUT']) if '.OUT' in side else None
    oracle_draw = _read(side['.DRAW']) if '.DRAW' in side else None
    stdin = _read(side['.IN']) if '.IN' in side else ''
    want_draw = '{drawlog}' in template
    if ttype == 'GRAPHIC' and not want_draw:
        st, detail = evaluate(ttype, hdr, source, dict(rc=0, stdout='', stderr='', timeout=False))
        return dict(type=ttype, status=st, detail=detail)
    tmp = tempfile.mkdtemp(prefix='fbcs-')
    try:
        fname = pid + '.BAS'
        shutil.copyfile(path, os.path.join(tmp, fname))
        argv = [a.replace('{file}', fname).replace('{drawlog}', 'draw.log') for a in shlex.split(template)]
        try:
            p = subprocess.run(argv, cwd=tmp, input=stdin, capture_output=True, text=True,
                               errors='replace', timeout=timeout)
            run = dict(rc=p.returncode, stdout=p.stdout, stderr=p.stderr, timeout=False)
        except subprocess.TimeoutExpired:
            run = dict(rc=124, stdout='', stderr='', timeout=True)
        except OSError as e:
            return dict(type=ttype, status='fail', detail=f'cannot start interpreter: {e}')
        drawlog = None
        if want_draw:
            dl = os.path.join(tmp, 'draw.log')
            drawlog = _read(dl) if os.path.isfile(dl) else ''
        expect = None
        if ttype == 'REJECT' and reject_codes is not None:
            expect = reject_codes.get(pid)
            if expect is None:
                return dict(type=ttype, status='fail', detail='no expected diagnostic for this REJECT program in --reject-codes')
        st, detail = evaluate(ttype, hdr, source, run, oracle_out, oracle_draw, drawlog, expect)
        return dict(type=ttype, status=st, detail=detail)
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


def run_suite(root, template, name, timeout=10, jobs=4, only=None, reject_codes=None):
    progs = fbcs.program_files(root)
    ids = [i for i in progs if not only or i in only]
    missing = [i for i in (only or []) if i not in progs]
    if missing:
        raise SystemExit(f'unknown program id(s): {", ".join(missing)}')
    with ThreadPoolExecutor(jobs) as ex:
        res = list(ex.map(lambda i: run_one(i, progs[i], template, timeout, reject_codes), ids))
    results = dict(zip(ids, res))
    summary = {s: sum(1 for r in res if r['status'] == s) for s in ('pass', 'fail', 'unsupported')}
    return {'format': 1, 'interpreter': name, 'summary': summary, 'results': results}


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--interpreter', required=True, help="command template, e.g. 'fullbasic {file}'")
    ap.add_argument('--root', default=fbcs.default_root(), help='Compliance directory (default: this checkout)')
    ap.add_argument('--output', help='write results JSON here (e.g. results/fullbasic.json)')
    ap.add_argument('--name', default='unnamed interpreter', help='label stored in the results file')
    ap.add_argument('--interpreter-commit', help='commit of the interpreter stored in the results file '
                    '(default: HEAD of the git checkout that contains this tree)')
    ap.add_argument('--interpreter-version', help='version of the interpreter stored in the results file '
                    '(default: the MARKETING_VERSION of the FullBASIC checkout that contains this tree, if any)')
    ap.add_argument('--timeout', type=float, default=10.0)
    ap.add_argument('--reject-codes', help='JSON {REJECT program id: diagnostic}; when given, a REJECT program passes only if '
                    'the interpreter reports that diagnostic (a program missing from the file fails)')
    ap.add_argument('--jobs', type=int, default=4)
    ap.add_argument('--only', nargs='*', help='run only these program ids')
    a = ap.parse_args(argv)
    codes = load_reject_codes(a.reject_codes) if a.reject_codes else None
    data = run_suite(a.root, a.interpreter, a.name, a.timeout, a.jobs, a.only, codes)
    for pid, r in data['results'].items():
        extra = f'  ({r["detail"]})' if r['detail'] else ''
        print(f'{r["status"].upper():<12}{pid}  {r["type"]}{extra}')
    s = data['summary']
    print(f'-- {s["pass"]} pass, {s["fail"]} fail, {s["unsupported"]} unsupported')
    if a.output:
        os.makedirs(os.path.dirname(os.path.abspath(a.output)), exist_ok=True)
        data['commit'] = a.interpreter_commit or fbcs.git_head(a.root)
        data['date'] = fbcs.utc_today()
        data['platform'] = f'{platform.system()} {platform.machine()}'
        version = a.interpreter_version or fbcs.marketing_version(fbcs.repo_root(a.root))
        if version and version != 'unknown':
            data['version'] = version
        with open(a.output, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, sort_keys=True)
            f.write('\n')
    return 1 if s['fail'] else 0


if __name__ == '__main__':
    sys.exit(main())
