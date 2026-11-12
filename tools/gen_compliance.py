#!/usr/bin/env python3
"""Generate COMPLIANCE_ANSI.md and COMPLIANCE_ECMA.md from claims/, interpretations.yaml and results/.

Usage: gen_compliance.py [--root DIR] [--results FILE] [--check]

Only claims that are `claimed` and whose tests ALL pass in the results file are
listed. Open claims (known failing), pending claims (no passing test yet) and claims whose
tests fail or are missing are counted but never listed. With --check nothing is written: exit 1 if a generated
file differs from the file on disk.

Each document has eight sections, in this order: 1 scope declaration, 2 identification
(version, commit, date, platform and the exact command that reproduces the run),
3 summary by chapter, 4 claims (plus the agreed interpretations), 5 implementation-defined
values, 6 enhancements over the standard, 7 not applicable with reason, 8 limits of
the evidence.
"""
import argparse
import json
import os
import platform
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import fbcs
import miniyaml

# Exact commands, run from the root of the suite, that produce results/fullbasic.json
# and then this document. <FullBasicCore> is the command-line interpreter built from the
# commit recorded in the results file.
REPRO_COMMAND = (
    "python3 tools/run_suite.py --interpreter '<FullBasicCore> --draw-log {drawlog} {file}' "
    "--reject-codes reject-codes-fullbasic.json --name 'FullBASIC v4' --output results/fullbasic.json\n"
    'python3 tools/gen_compliance.py'
)

SCOPE_ANSI = [
    'This document records the conformance claims of the **FullBASIC v4** interpreter '
    'against **ANSI X3.113-1987 (FIPS PUB 68-2)**. The implementation claims the modules '
    'defined by §2 (l.470-503):',
    '',
    '- **Core** (§4-§12),',
    '- **Enhanced Files** (§11, organizations INTERNAL and NATIVE),',
    '- **Graphics** (§13),',
    '- **Fixed Decimal** (§15).',
    '',
    '**Section 14 (Real Time) is not claimed**: it is optional in the standard and is not '
    'implemented (claim A-14-01, section 7). **Section 16 (Editing) is not claimed as a '
    'module**: the interpreter does not accept the §16 editing commands as program text; '
    'the host application\'s own source editor provides the editing functionality instead '
    '(claim A-16-01, section 7).',
]

SCOPE_ECMA = [
    'This document records the conformance claims of the **FullBASIC v4** interpreter '
    'against **ECMA-116 (BASIC)**, mapped clause by clause through the `ecma` field of '
    'each claim in `claims/`.',
    '',
    'The implementation claims **BASIC-2 plus the optional Graphics module** (ECMA-116 §2). '
    '**BASIC-1 is not claimed**: ECMA BASIC-1 reserves a long list of keywords and forbids '
    'using them as identifiers (ECMA-116 §3.2.19), while this interpreter — following '
    'ANSI X3.113-1987 §3.2 and ECMA BASIC-2 — accepts keywords as identifiers. Every '
    'BASIC-1 program is also a BASIC-2 program, so the implementation claims the higher '
    'level. ECMA-116 has no real-time or editing sections (ECMA-116 §2.5); neither is '
    'claimed (see COMPLIANCE_ANSI.md, section 7).',
    '',
    'There is no separate ECMA mode: the body of ECMA-116 gives every exception the same code '
    'and the same fatality as ANSI X3.113-1987, so the interpreter, which implements the ANSI '
    'codes, serves both standards. Some descriptions in ECMA Table 2 are worded differently '
    '(7305, 7317, 7318, 7322), but the clauses that raise them say the same as ANSI.',
]

LIMITS = [
    '- **Self-declaration, not certification.** This document is published by the '
    'implementer. {std} defines conformance but does not certify implementations, and no '
    'external body has tested or endorsed this one: the claims are backed only by the '
    'programs listed above, run on the platform and at the commit identified in section 2.',
    '- **What a program can prove.** That this interpreter accepts, rejects or executes '
    'each specific program with the specific result recorded, on that host. It cannot prove '
    'anything about programs not run, other hosts, platforms, operating-system versions or '
    'commits.',
    '- **Real time (ANSI §14) is not claimed** and cannot be probed by this suite: no '
    'real-time programs, parallel sections or event handling are run (ANSI §14; ECMA-116 '
    '§2.5).',
    '- **Editing (ANSI §16) is not claimed** as a module; editing is provided by the host '
    'application\'s editor, not by §16 commands in the program text (section 7).',
    '- **Devices other than the console and files.** The command-line host exposes a single '
    'device, the console on channel zero, so exceptions that require another device (for '
    'example 7205 and 7311, Table 9 l.12919 and l.12934) cannot occur and are marked not '
    'applicable in section 7.',
    '- **The wording of default exception reports** beyond the exception code and the line '
    'number is implementation-defined (§2.4 l.617-620); the tests check the code and the '
    'line, not the text around them.',
    '- **Graphics** are compared through the interpreter\'s primitive trace '
    '(`--draw-log {drawlog}`), not by inspecting a rendered screen. The trace records the '
    'primitives, the window, viewport, clip, text-justify and color-mix settings and the '
    'values ASK returns, but not the line style, point style or color a primitive is drawn '
    'with, and it records the primitives before clipping, which the host renderer does: how '
    'each style and color looks, and the clipping itself, are checked only through ASK.',
    '- **Resource-constraint exceptions** (§2.4 l.593-595) depend on the host\'s memory and '
    'limits; only the tested cases are claimed. Numeric precision and range are '
    'implementation-defined (Appendix C, §5.6) and are declared in section 5.',
    '- **Absence is not evidence.** Clauses without a listed claim (the pending counts in '
    'the header and in section 3) are not a statement of non-conformance.',
]

ENH_INTRO_ANSI = ('ANSI §2.2 (9) (l.553-556) requires the implementation to be accompanied by '
                  'documentation that describes and identifies all enhancements to the language. '
                  'A program that uses an enhancement is **not a conforming program** and is not '
                  'portable to other implementations. The enhancements of this interpreter, each '
                  'verified by its test, are:')
ENH_INTRO_ECMA = ('ECMA-116 is a subset of ANSI X3.113-1987 and defines none of the '
                  'enhancements listed in section 6 of COMPLIANCE_ANSI.md; none is claimed here.')


def clause_key(c):
    return tuple(int(p) if p.isdigit() else 0 for p in str(c).split('.'))


def esc(text):
    return str(text).replace('|', '\\|').replace('\n', ' ')


def repo_root_of(root):
    return os.path.dirname(os.path.abspath(root))


def platform_name():
    sysname = platform.system()
    if sysname == 'Darwin':
        sysname = 'macOS'
    return (sysname + ' ' + platform.machine()).strip() or 'unknown'


def identification(root, raw):
    """Identification of the run: the stamp recorded in the results file when the
    suite ran (commit/date/platform), falling back to the live values."""
    repo = repo_root_of(root)
    commit = raw.get('commit') or fbcs.git_head(root)
    date = raw.get('date') or fbcs.utc_today()
    plat = raw.get('platform') or platform_name()
    if plat and plat.split()[0] == 'Darwin':
        plat = 'macOS' + plat[len('Darwin'):]
    return {
        'version': raw.get('version') or fbcs.marketing_version(repo),
        'commit': commit,
        'date': date,
        'platform': plat,
    }


def load_interpretations(root):
    path = os.path.join(root, 'interpretations.yaml')
    if not os.path.isfile(path):
        return []
    try:
        recs = miniyaml.load(path)
    except (miniyaml.MiniYamlError, OSError):
        return []
    return [r for r in recs if isinstance(r, dict)]


def is_enh(c):
    return str(c.get('id', '')).startswith('A-ENH-')


def group_of(c):
    """Summary row of a listed claim: its chapter, or a named group."""
    if is_enh(c):
        return 'Enhancements'
    if c.get('kind') == 'implementation-defined':
        return 'Implementation-defined'
    return None


def chapter_of(c, field):
    return str(c.get(field, '')).split('.')[0]


def render(root, title, std_name, field, claims, results, meta, interp, ident,
           scope_paras, enh_intro):
    sel = [c for c in claims if c.get(field)]
    listed = [c for c in sel if fbcs.is_listed(c, results)]
    open_n = sum(1 for c in sel if fbcs.claim_status(c) == 'open')
    pending_n = sum(1 for c in sel if fbcs.claim_status(c) == 'pending')
    other = len(sel) - len(listed) - open_n - pending_n
    main = [c for c in listed if c.get('kind') not in ('implementation-defined', 'not-applicable')
            and not is_enh(c)]
    idef = [c for c in listed if c.get('kind') == 'implementation-defined']
    enh = [c for c in listed if is_enh(c)]
    na = [c for c in listed if c.get('kind') == 'not-applicable']
    interps = [i for i in load_interpretations(root) if i.get(field)]
    clause_hdr = 'Clause' if field == 'clause' else 'ECMA clause'

    p = meta.get('pass', sum(1 for r in results.values() if r.get('status') == 'pass'))
    f = meta.get('fail', sum(1 for r in results.values() if r.get('status') == 'fail'))
    u = meta.get('unsupported', sum(1 for r in results.values() if r.get('status') == 'unsupported'))

    L = [f'# {title}', '',
         '<!-- Generated by Compliance/tools/gen_compliance.py. Do not edit by hand. -->', '',
         f'Interpreter under test: **{esc(interp)}**. Reference: {std_name}.', '',
         '> **Only claims whose tests pass are listed.** A claim appears here when it is '
         'marked `claimed` and every test it cites passes in `results/fullbasic.json`. '
         'Known failures (`open` claims) and claims without a passing result are not listed, '
         'so absence from this document is not a statement of conformance either way.', '',
         f'Claims listed: **{len(listed)}**. Known open (not listed): {open_n}. '
         f'Pending, without a passing test yet (not listed): {pending_n}. '
         f'Not listed for lack of a passing result: {other}.', '',
         '## 1. Scope', '']
    L += scope_paras + ['', '## 2. Identification', '',
          '| Item | Value |', '|---|---|',
          '| Interpreter | FullBASIC v4 |',
          f'| Version | {esc(ident["version"])} |',
          f'| Interpreter commit (recorded in the results file) | `{esc(ident["commit"])}` |',
          f'| Date (UTC) | {esc(ident["date"])} |',
          f'| Platform | {esc(ident["platform"])} |',
          f'| Results | `results/fullbasic.json`: {len(results)} programs — '
          f'{p} pass, {f} fail, {u} unsupported (interpreter label "{esc(interp)}") |', '',
          'Run from the root of the suite (the `Compliance` directory of the FullBASIC repository), the exact '
          'commands that produced the results file and then this document are:', '',
          '```bash', REPRO_COMMAND, '```', '',
          '(`{file}` and `{drawlog}` are expanded by `run_suite.py`; `<FullBasicCore>` is the '
          'command-line interpreter built from the commit recorded above, which is the build the '
          'results file and this document were produced with.)', '',
          '## 3. Summary by chapter', '',
          '| Chapter | Claims | Tests | Passed |', '|---|---|---|---|']
    groups = {}
    for c in listed:
        key = group_of(c) or chapter_of(c, field)
        groups.setdefault(key, []).append(c)
    for c in sel:  # a chapter with only pending/open claims still gets its (zero) row
        groups.setdefault(chapter_of(c, field), [])
    groups.setdefault('Enhancements', [])
    groups.setdefault('Implementation-defined', [])

    def sort_key(k):
        if k == 'Enhancements':
            return (2, 0, k)
        if k == 'Implementation-defined':
            return (1, 0, k)
        return (0, int(k) if str(k).isdigit() else 0, k)

    tot_c = tot_t = tot_p = 0
    for key in sorted(groups, key=sort_key):
        cs = groups[key]
        tests = sorted({t for c in cs for t in (c.get('tests') or [])})
        passed = sum(1 for t in tests if fbcs.passing(results, t))
        tot_c += len(cs)
        tot_t += len(tests)
        tot_p += passed
        L.append(f'| {esc(key)} | {len(cs)} | {len(tests)} | {passed} |')
    L += [f'| **Total** | **{tot_c}** | **{tot_t}** | **{tot_p}** |', '',
          f'## 4. Claims', '']
    if main:
        L += ['', f'| {clause_hdr} | Claim ID | Kind | Module | Claim | Tests |',
              '|---|---|---|---|---|---|']
        for c in sorted(main, key=lambda c: (clause_key(c[field]), c['id'])):
            tests = ', '.join(c.get('tests') or []) or '-'
            L.append(f'| {esc(c[field])} | {esc(c["id"])} | {c["kind"]} | {c["module"]} | '
                     f'{esc(c["claim"])} | {tests} |')
    else:
        L += ['', '_No claims are listed yet._']
    if interps:
        L += ['', '### Agreed interpretations', '',
              'Readings adopted by this implementation where the standard admits more than one '
              'reading or leaves the choice to the project:', '',
              f'| {clause_hdr} | Topic | Reading adopted | Standard lines |', '|---|---|---|---|']
        for i in sorted(interps, key=lambda i: clause_key(i.get('clause', ''))):
            L.append(f'| {esc(i.get(field) or i.get("clause"))} | {esc(i.get("topic"))} | '
                     f'{esc(i.get("reading"))} | {esc(i.get("base"))} |')
    L += ['', '## 5. Implementation-defined values', '',
          'Appendix C of the standard lists the features whose value each implementation '
          'chooses; the claimed items and their values are:', '']
    if idef:
        L += [f'| {clause_hdr} | Claim ID | Module | Item | Value | Tests |',
              '|---|---|---|---|---|---|']
        for c in sorted(idef, key=lambda c: (clause_key(c[field]), c['id'])):
            L.append(f'| {esc(c[field])} | {esc(c["id"])} | {c["module"]} | {esc(c["claim"])} | '
                     f'{esc(c.get("value"))} | {", ".join(c.get("tests") or [])} |')
    else:
        L += ['_No implementation-defined item is claimed yet._']
    L += ['', '## 6. Enhancements over the standard', '', enh_intro, '']
    if enh:
        L += [f'| {clause_hdr} | Claim ID | Module | Enhancement | Tests |', '|---|---|---|---|---|']
        for c in sorted(enh, key=lambda c: (clause_key(c[field]), c['id'])):
            L.append(f'| {esc(c[field])} | {esc(c["id"])} | {c["module"]} | {esc(c["claim"])} | '
                     f'{", ".join(c.get("tests") or [])} |')
    else:
        L += ['_None._']
    L += ['', '## 7. Not applicable', '',
          'Claims that do not apply to this implementation, with the reason:', '']
    if na:
        L += [f'| {clause_hdr} | Claim ID | Module | Claim | Reason |', '|---|---|---|---|---|']
        for c in sorted(na, key=lambda c: (clause_key(c[field]), c['id'])):
            L.append(f'| {esc(c[field])} | {esc(c["id"])} | {c["module"]} | {esc(c["claim"])} | '
                     f'{esc(c.get("reason"))} |')
    else:
        L += ['_None._']
    L += ['', '## 8. Limits of the evidence', '']
    L += [p.replace('{std}', std_name) for p in LIMITS]
    L.append('')
    return '\n'.join(L)


def generate(root, results_path=None):
    claims, errs = fbcs.load_claims(root)
    if errs:
        raise SystemExit('\n'.join(errs))
    rp = results_path or os.path.join(root, 'results', 'fullbasic.json')
    results, err = fbcs.load_results(rp)
    if err:
        raise SystemExit(err)
    with open(rp, encoding='utf-8') as f:
        raw = json.load(f)
    interp = raw.get('interpreter', 'unknown')
    meta = raw.get('summary') or {}
    ident = identification(root, raw)
    return {
        'COMPLIANCE_ANSI.md': render(root, 'ANSI X3.113-1987 Full BASIC conformance claims',
                                     'ANSI X3.113-1987 (FIPS PUB 68-2)', 'clause', claims,
                                     results, meta, interp, ident, SCOPE_ANSI, ENH_INTRO_ANSI),
        'COMPLIANCE_ECMA.md': render(root, 'ECMA-116 conformance claims',
                                     'ECMA-116 (BASIC), mapped through the `ecma` field of each claim',
                                     'ecma', claims, results, meta, interp, ident,
                                     SCOPE_ECMA, ENH_INTRO_ECMA),
    }


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--root', default=fbcs.default_root())
    ap.add_argument('--results')
    ap.add_argument('--check', action='store_true')
    a = ap.parse_args(argv)
    docs = generate(a.root, a.results)
    bad = 0
    for name, text in docs.items():
        path = os.path.join(a.root, name)
        text = text.rstrip('\n') + '\n'
        if a.check:
            cur = open(path, encoding='utf-8').read() if os.path.isfile(path) else None
            if cur != text:
                print(f'{name}: out of date (run Compliance/tools/gen_compliance.py)')
                bad += 1
        else:
            with open(path, 'w', encoding='utf-8') as f:
                f.write(text)
            print(f'wrote {name}')
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
