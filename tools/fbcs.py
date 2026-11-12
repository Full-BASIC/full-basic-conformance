"""Shared loading code for the FBCS tools (standard library only)."""
import datetime
import glob
import json
import os
import re
import subprocess

import miniyaml

TYPES = ('SELF', 'OUTPUT', 'REJECT', 'FATAL', 'WARN', 'INPUT', 'GRAPHIC')
KINDS = ('syntax', 'semantics', 'exception', 'implementation-defined', 'not-applicable')
MODULES = ('core', 'files', 'graphics', 'fixed')
STATUSES = ('claimed', 'open', 'pending')

RE_COVERS = re.compile(r'^l\.\d+(-\d+)?$')
RE_PROGRAM_ID = re.compile(r'^[A-Z]{3,4}-\d{4}$')
RE_HEADER = re.compile(r'^\s*\d+\s+REM\s+(FBCS|CLAIM|TYPE|EXPECT)\b[ \t]*(.*?)\s*$', re.I)
RE_ANY_REM = re.compile(r'^\s*\d+\s+REM\b', re.I)


def default_root():
    return os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def repo_root(root):
    """Repository that contains this Compliance tree (its parent directory)."""
    return os.path.dirname(os.path.abspath(root))


def git_head(repo):
    """HEAD commit of `repo`, or 'unknown' when it is not a git checkout."""
    try:
        p = subprocess.run(['git', '-C', repo, 'rev-parse', 'HEAD'],
                           capture_output=True, text=True, timeout=15)
        if p.returncode == 0 and p.stdout.strip():
            return p.stdout.strip()
    except (OSError, subprocess.SubprocessError):
        pass
    return 'unknown'


def marketing_version(repo):
    """MARKETING_VERSION of the FullBASIC core project in `repo`, or 'unknown' outside it."""
    import glob
    import re
    cands = glob.glob(os.path.join(repo, 'FullBasicCore', '*.xcodeproj', 'project.pbxproj'))
    for p in cands:
        try:
            with open(p, encoding='utf-8', errors='replace') as f:
                m = re.search(r'MARKETING_VERSION\s*=\s*([^;]+);', f.read())
        except OSError:
            continue
        if m:
            return m.group(1).strip()
    return 'unknown'


def utc_today():
    return datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%d')


def parse_header(text):
    """Return the FBCS header fields found in the leading REM block of a program."""
    hdr = {}
    for line in text.splitlines():
        if not line.strip():
            continue
        if not RE_ANY_REM.match(line):
            break
        m = RE_HEADER.match(line)
        if m:
            key = m.group(1).upper()
            if key in hdr:
                hdr.setdefault('_duplicates', []).append(key)
            hdr[key] = m.group(2)
    return hdr


def program_files(root):
    """Map program id (file stem) -> absolute path of its .BAS file."""
    out = {}
    for p in sorted(glob.glob(os.path.join(root, 'programs', '*', '*.BAS'))):
        out[os.path.splitext(os.path.basename(p))[0]] = p
    return out


def sidecars(path):
    base = os.path.splitext(path)[0]
    return {ext: base + ext for ext in ('.OUT', '.IN', '.DRAW') if os.path.isfile(base + ext)}


def load_claims(root):
    """Return (claims, errors). Each claim carries '_file'."""
    claims, errors = [], []
    for p in sorted(glob.glob(os.path.join(root, 'claims', '*.yaml'))):
        rel = os.path.relpath(p, root)
        try:
            recs = miniyaml.load(p)
        except (miniyaml.MiniYamlError, OSError) as e:
            errors.append(f'{rel}: cannot parse: {e}')
            continue
        for r in recs:
            r['_file'] = rel
            claims.append(r)
    return claims, errors


def load_results(path):
    """Return (results dict id -> record, error or None)."""
    if not os.path.isfile(path):
        return {}, f'{path}: results file not found (run tools/run_suite.py --output results/fullbasic.json)'
    try:
        with open(path, encoding='utf-8') as f:
            data = json.load(f)
        res = data['results']
        if not isinstance(res, dict):
            raise ValueError('"results" must be an object')
        return res, None
    except (ValueError, KeyError, OSError) as e:
        return {}, f'{path}: invalid results file: {e}'


def claim_status(c):
    s = c.get('status')
    return 'claimed' if s is None else s


def passing(results, tid):
    return results.get(tid, {}).get('status') == 'pass'


def is_listed(claim, results):
    """A claim is published only if it is claimed and every one of its tests passes."""
    tests = claim.get('tests') or []
    if claim_status(claim) != 'claimed':
        return False
    if claim.get('kind') == 'not-applicable':
        return True
    return bool(tests) and all(passing(results, t) for t in tests)
