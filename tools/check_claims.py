#!/usr/bin/env python3
"""Consistency check between claims, programs and results (exit 1 on any error).

Usage: check_claims.py [--root DIR] [--results FILE] [--standard FILE]

Rules:
  * claims/*.yaml parse with the miniyaml subset; required fields present and valid.
  * claim ids are unique; each claim lists at least one test (not-applicable claims
    carry a `reason` instead; implementation-defined claims carry a `value` and a test).
  * every test id names a program; every program belongs to a claim and its REM header
    (FBCS, CLAIM, TYPE) matches the registry and the file name.
  * claimed claims: all their tests pass in the results file.
  * pending claims (`status: pending`): inventoried from the standard but not yet backed
    by a passing test. They may have no tests (nor a `value` if implementation-defined);
    listed tests must exist and must NOT all pass (otherwise make the claim claimed).
    They are never listed in the COMPLIANCE_*.md documents.
  * `covers: [l.N, l.N-M]` (optional) names the lines of the standard a claim covers;
    the maintainers' inventory tool reads it.
  * open claims (`status: open`, `card: <work item>`): known failing, not claimed. Their tests
    must exist but must NOT all pass (otherwise promote the claim to claimed).
  * a program may only name files in its working directory: a `NAME "..."` literal with a
    path separator, `..`, `~` or a drive prefix is an error (run_suite.py gives each program
    an empty cwd, so anything else leaks outside it).
  * no `claim` text contains a run of more than 8 words copied from the standard
    (checked when the standard file is available).
  * no claim, reading or program comment refers to the maintainers' private notes (work
    items such as TR12, findings such as 6-H4, source files, private paths).
"""
import argparse
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import fbcs

MAX_RUN = 8
RE_CARD = re.compile(r'^[A-Za-z][\w.-]*$')
# References to the maintainers' private notes (work items, findings, source files, private
# paths). The tree is published, so none may appear in claims, readings or program comments.
RE_INTERNAL = re.compile(
    r'(?<![\w.-])(?:TC\d+(?:\.\d+)?[a-z]*|TC81[A-Z]*-\d+|TR\d+[A-Za-z]?|CLN?-\d+|N[uú]cleo E\d+|IC-\d+'
    r'|§?\d+-H\d+|T\d+\.\d+[a-z]?)(?!\w)|\bDocs/|\bscripts/|\b\w+\.(?:cpp|hpp|mm|swift)\b')
YAML_SKIP = ('- id:', '  tests:', '  covers:', '  card:')
RE_CLAIM_ID = re.compile(r'^[A-Z]-[\w.]+(-[\w.]+)*$')
RE_NAME_LIT = re.compile(r'\bNAME\s+"([^"]*)"', re.I)
REQUIRED = ('id', 'clause', 'module', 'kind', 'claim')


def _covers_ok(ref):
    nums = [int(n) for n in re.findall(r'\d+', ref)]
    return len(nums) == 1 or nums[0] <= nums[1]


def words(text):
    return re.findall(r'[a-z0-9]+', text.lower())


def standard_ngrams(path, n=MAX_RUN + 1):
    with open(path, encoding='utf-8', errors='replace') as f:
        w = words(f.read())
    return {tuple(w[i:i + n]) for i in range(len(w) - n + 1)}


def default_standard(root):
    cand = os.path.join(os.path.dirname(root), 'Docs', 'estandar', 'fipspub68-2-ansi-full-basic.md')
    return cand if os.path.isfile(cand) else None


def check(root, results_path=None, standard=None):
    errors, notes = [], []
    claims, errs = fbcs.load_claims(root)
    errors += errs
    results, err = fbcs.load_results(results_path or os.path.join(root, 'results', 'fullbasic.json'))
    if err:
        errors.append(err)
    progs = fbcs.program_files(root)

    # --- claim records
    seen = {}
    by_id = {}
    for c in claims:
        where = f'{c["_file"]}: claim {c.get("id")!r}'
        for k in REQUIRED:
            if not isinstance(c.get(k), str) or not c.get(k).strip():
                errors.append(f'{where}: missing or non-string field "{k}"')
        cid = c.get('id')
        if isinstance(cid, str):
            if not RE_CLAIM_ID.match(cid):
                errors.append(f'{where}: malformed id (expected like A-9.2.4.1-01 or E-1005)')
            if cid in seen:
                errors.append(f'{where}: duplicate id (also in {seen[cid]})')
            seen[cid] = c['_file']
            by_id[cid] = c
        if c.get('kind') not in fbcs.KINDS:
            errors.append(f'{where}: kind must be one of {", ".join(fbcs.KINDS)}')
        if c.get('module') not in fbcs.MODULES:
            errors.append(f'{where}: module must be one of {", ".join(fbcs.MODULES)}')
        status = fbcs.claim_status(c)
        if status not in fbcs.STATUSES:
            errors.append(f'{where}: status must be one of {", ".join(fbcs.STATUSES)}')
        if status == 'open':
            if not isinstance(c.get('card'), str) or not RE_CARD.match(c['card']):
                errors.append(f'{where}: status open requires `card: <work item>` (the item that fixes it)')
        elif c.get('card') is not None:
            errors.append(f'{where}: `card` is only allowed on open claims')
        tests = c.get('tests')
        if tests is None:
            tests = []
        if not isinstance(tests, list) or not all(isinstance(t, str) for t in tests):
            errors.append(f'{where}: tests must be a list of program ids')
            tests = []
        if c.get('kind') == 'not-applicable':
            if not isinstance(c.get('reason'), str) or not c['reason'].strip():
                errors.append(f'{where}: not-applicable requires a `reason`')
        else:
            if not tests and status != 'pending':
                errors.append(f'{where}: a claim must cite at least one test '
                              '(or be `status: pending` while it has none)')
            if c.get('kind') == 'implementation-defined' and status != 'pending' \
                    and (c.get('value') is None or c.get('value') == ''):
                errors.append(f'{where}: implementation-defined requires a `value`')
        for t in tests:
            if t not in progs:
                errors.append(f'{where}: test {t} has no program under programs/')
        covers = c.get('covers')
        if covers is not None:
            if not isinstance(covers, list) or not all(isinstance(x, str) and fbcs.RE_COVERS.match(x) and
                                                       _covers_ok(x) for x in covers):
                errors.append(f'{where}: covers must be a list of l.N or l.N-M (N <= M) line references')
        if status == 'claimed' and c.get('kind') != 'not-applicable':
            for t in tests:
                if t in progs and not fbcs.passing(results, t):
                    st = results.get(t, {}).get('status', 'missing')
                    errors.append(f'{where}: claimed but test {t} does not pass in results ({st}); '
                                  'fix it or mark the claim `status: open` with a `card`')
        if status == 'pending' and tests and all(t in progs for t in tests) \
                and all(fbcs.passing(results, t) for t in tests):
            errors.append(f'{where}: marked pending but all its tests pass; make it claimed')
        if status == 'open' and tests and all(fbcs.passing(results, t) for t in tests if t in progs) \
                and all(t in progs for t in tests):
            errors.append(f'{where}: marked open but all its tests pass; make it claimed and drop `card`')

    # --- programs
    owned = {t for c in claims for t in (c.get('tests') or []) if isinstance(t, str)}
    for pid, path in progs.items():
        rel = os.path.relpath(path, root)
        if not fbcs.RE_PROGRAM_ID.match(pid):
            errors.append(f'{rel}: file name must look like AAA-0000.BAS')
        if not re.match(r'^\d\d-[a-z0-9-]+$', os.path.basename(os.path.dirname(path))):
            errors.append(f'{rel}: directory must look like NN-area (lowercase)')
        with open(path, encoding='utf-8', errors='replace') as f:
            src = f.read()
        hdr = fbcs.parse_header(src)
        if hdr.get('_duplicates'):
            errors.append(f'{rel}: duplicate header field(s) {", ".join(hdr["_duplicates"])}')
        if hdr.get('FBCS') != pid:
            errors.append(f'{rel}: header `REM FBCS` must equal the file name ({pid}), found {hdr.get("FBCS")!r}')
        ttype = (hdr.get('TYPE') or '').upper()
        if ttype not in fbcs.TYPES:
            errors.append(f'{rel}: header `REM TYPE` must be one of {", ".join(fbcs.TYPES)}')
        cl = hdr.get('CLAIM')
        if not cl:
            errors.append(f'{rel}: missing `REM CLAIM` header')
        elif cl not in by_id:
            errors.append(f'{rel}: header claim {cl} is not in claims/')
        elif pid not in (by_id[cl].get('tests') or []):
            errors.append(f'{rel}: claim {cl} does not list {pid} in its tests')
        if pid not in owned:
            errors.append(f'{rel}: program belongs to no claim')
        side = fbcs.sidecars(path)
        if ttype == 'OUTPUT' and '.OUT' not in side:
            errors.append(f'{rel}: OUTPUT test needs {pid}.OUT')
        if ttype == 'INPUT' and '.IN' not in side:
            errors.append(f'{rel}: INPUT test needs {pid}.IN')
        if ttype == 'GRAPHIC' and '.DRAW' not in side:
            errors.append(f'{rel}: GRAPHIC test needs {pid}.DRAW')
        if ttype in ('FATAL', 'WARN') and not re.match(r'^\d+\s+\d+$', hdr.get('EXPECT') or ''):
            errors.append(f'{rel}: {ttype} test needs `REM EXPECT <code> <line>`')
        for ln in src.splitlines():
            if re.match(r'\s*\d+\s+REM\b', ln, re.I):
                continue
            for lit in RE_NAME_LIT.findall(ln):
                if '/' in lit or '\\' in lit or lit.startswith(('..', '~')) or re.match(r'^[A-Za-z]:', lit):
                    errors.append(f'{rel}: file name "{lit}" leaves the working directory (programs run in an '
                                  f'empty cwd and may only name files in it)')
        if ttype == 'REJECT' and not re.search(r'PRINT\s+"EXECUTED"', src, re.I):
            errors.append(f'{rel}: REJECT test must print "EXECUTED" before the non-conforming construct')
    for p in sorted(os.listdir(os.path.join(root, 'programs'))) if os.path.isdir(os.path.join(root, 'programs')) else []:
        d = os.path.join(root, 'programs', p)
        if os.path.isdir(d):
            for f in sorted(os.listdir(d)):
                stem, ext = os.path.splitext(f)
                if ext in ('.OUT', '.IN', '.DRAW') and stem not in progs:
                    errors.append(f'programs/{p}/{f}: no matching {stem}.BAS')
                elif ext not in ('.BAS', '.OUT', '.IN', '.DRAW'):
                    errors.append(f'programs/{p}/{f}: unexpected file')

    # --- no references to private notes in what is published
    yamls = [os.path.join('claims', f) for f in sorted(os.listdir(os.path.join(root, 'claims')))
             if f.endswith('.yaml')] if os.path.isdir(os.path.join(root, 'claims')) else []
    if os.path.isfile(os.path.join(root, 'interpretations.yaml')):
        yamls.append('interpretations.yaml')
    for rel in yamls:
        with open(os.path.join(root, rel), encoding='utf-8') as f:
            for n, ln in enumerate(f, 1):
                if not ln.startswith(YAML_SKIP):
                    m = RE_INTERNAL.search(ln)
                    if m:
                        errors.append(f'{rel}:{n}: internal reference {m.group(0)!r} (the tree is published)')
    for pid, path in sorted(progs.items()):
        rel = os.path.relpath(path, root)
        with open(path, encoding='utf-8', errors='replace') as f:
            for n, ln in enumerate(f, 1):
                c = re.match(r'\s*\d+\s+REM\b(.*)', ln, re.I) or re.search(r'!(.*)$', ln)
                m = c and RE_INTERNAL.search(c.group(1))
                if m:
                    errors.append(f'{rel}:{n}: internal reference {m.group(0)!r} in a comment (the tree is published)')

    # --- results must describe known programs
    for rid in results:
        if rid not in progs:
            errors.append(f'results: {rid} is not a program (stale results file?)')

    # --- 8-word rule
    std = standard or default_standard(root)
    if std:
        grams = standard_ngrams(std)
        for c in claims:
            w = words(c.get('claim') or '')
            for i in range(len(w) - MAX_RUN):
                if tuple(w[i:i + MAX_RUN + 1]) in grams:
                    errors.append(f'{c["_file"]}: claim {c.get("id")!r} copies more than {MAX_RUN} consecutive '
                                  f'words from the standard: "{" ".join(w[i:i + MAX_RUN + 1])} ..."')
                    break
    else:
        notes.append('standard text not found: the 8-word rule was not checked (use --standard FILE)')
    return errors, notes


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--root', default=fbcs.default_root())
    ap.add_argument('--results')
    ap.add_argument('--standard', help='text of the standard, for the 8-word rule')
    a = ap.parse_args(argv)
    errors, notes = check(a.root, a.results, a.standard)
    for n in notes:
        print(f'note: {n}')
    for e in errors:
        print(f'ERROR: {e}')
    print(f'check_claims: {len(errors)} error(s)')
    return 1 if errors else 0


if __name__ == '__main__':
    sys.exit(main())
