import json, os, sys, tempfile, shutil
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..'))


def write(path, text):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(text)


def prog(pid, claim, ttype, body='', extra=''):
    return (f'1 REM FBCS {pid}\n2 REM CLAIM {claim}\n3 REM TYPE {ttype}\n{extra}{body}')


class Tree:
    """A throw-away Compliance tree."""
    def __init__(self):
        self.root = tempfile.mkdtemp(prefix='fbcs-test-')

    def cleanup(self):
        shutil.rmtree(self.root, ignore_errors=True)

    def path(self, *p):
        return os.path.join(self.root, *p)

    def program(self, area, pid, text, **side):
        write(self.path('programs', area, pid + '.BAS'), text)
        for ext, content in side.items():
            write(self.path('programs', area, pid + '.' + ext.upper()), content)

    def claims(self, name, text):
        write(self.path('claims', name), text)

    def results(self, mapping, interpreter='fake'):
        res = {k: {'type': 'SELF', 'status': v, 'detail': ''} for k, v in mapping.items()}
        write(self.path('results', 'fullbasic.json'), json.dumps({'format': 1, 'interpreter': interpreter, 'results': res}))


CLAIM = '''- id: {id}
  clause: "{clause}"
  ecma: {ecma}
  module: core
  kind: {kind}
{extra}  claim: "{claim}"
  tests: [{tests}]
'''


def claim(id='A-1.1-01', clause='1.1', ecma='null', kind='semantics', claim='Something small is true.', tests='AAA-0001', extra=''):
    return CLAIM.format(id=id, clause=clause, ecma=ecma, kind=kind, claim=claim, tests=tests, extra=extra)
