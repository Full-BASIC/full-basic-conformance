import json, os, unittest
from helpers import Tree, prog, claim, write
import gen_compliance


class GenTests(unittest.TestCase):
    def setUp(self):
        self.t = Tree()
        self.addCleanup(self.t.cleanup)

    def test_empty_tree_generates_valid_empty_documents(self):
        self.t.claims('ansi-01.yaml', '')
        self.t.results({})
        docs = gen_compliance.generate(self.t.root)
        self.assertEqual(set(docs), {'COMPLIANCE_ANSI.md', 'COMPLIANCE_ECMA.md'})
        for text in docs.values():
            self.assertIn('Only claims whose tests pass are listed', text)
            self.assertIn('_No claims are listed yet._', text)
            self.assertIn('Claims listed: **0**', text)

    def test_pending_claims_are_counted_and_never_listed(self):
        t = self.t
        t.claims('ansi-01.yaml',
                 claim(id='A-1.1-01', tests='AAA-0001') +
                 claim(id='A-1.1-02', clause='1.2', tests='', extra='  status: pending\n'))
        t.results({'AAA-0001': 'pass'})
        ansi = gen_compliance.generate(t.root)['COMPLIANCE_ANSI.md']
        self.assertIn('A-1.1-01', ansi)
        self.assertNotIn('A-1.1-02', ansi)
        self.assertIn('Claims listed: **1**. Known open (not listed): 0. Pending, without a passing test yet '
                      '(not listed): 1. Not listed for lack of a passing result: 0.', ansi)

    def test_only_passing_claimed_claims_are_listed(self):
        t = self.t
        t.claims('ansi-01.yaml',
                 claim(id='A-1.1-01', clause='1.10', ecma='"4.2"', tests='AAA-0001') +
                 claim(id='A-1.1-02', clause='1.2', tests='AAA-0002') +
                 claim(id='A-1.1-03', clause='1.3', tests='AAA-0003', extra='  status: open\n  card: ISSUE-12\n') +
                 claim(id='A-1.1-04', clause='1.4', kind='implementation-defined', tests='AAA-0001', extra='  value: 15\n'))
        t.results({'AAA-0001': 'pass', 'AAA-0002': 'fail', 'AAA-0003': 'fail'})
        docs = gen_compliance.generate(t.root)
        ansi, ecma = docs['COMPLIANCE_ANSI.md'], docs['COMPLIANCE_ECMA.md']
        self.assertIn('A-1.1-01', ansi)
        self.assertNotIn('A-1.1-02', ansi)
        self.assertNotIn('A-1.1-03', ansi)
        self.assertNotIn('ISSUE-12', ansi)
        self.assertIn('Implementation-defined values', ansi)
        self.assertIn('| 15 |', ansi)
        self.assertIn('Claims listed: **2**. Known open (not listed): 1. Pending, without a passing test yet (not listed): 0. Not listed for lack of a passing result: 1.', ansi)
        self.assertIn('A-1.1-01', ecma)           # has an ecma clause
        self.assertNotIn('A-1.1-02', ecma)

    def test_clause_order_is_numeric(self):
        t = self.t
        t.claims('ansi-01.yaml', claim(id='A-1.1-01', clause='1.10') + claim(id='A-1.1-02', clause='1.2'))
        t.results({'AAA-0001': 'pass'})
        ansi = gen_compliance.generate(t.root)['COMPLIANCE_ANSI.md']
        self.assertLess(ansi.index('A-1.1-02'), ansi.index('A-1.1-01'))

    def test_check_mode(self):
        t = self.t
        t.claims('ansi-01.yaml', '')
        t.results({})
        self.assertEqual(gen_compliance.main(['--root', t.root, '--check']), 1)      # files missing
        self.assertEqual(gen_compliance.main(['--root', t.root]), 0)
        self.assertEqual(gen_compliance.main(['--root', t.root, '--check']), 0)
        write(t.path('COMPLIANCE_ANSI.md'), 'stale\n')
        self.assertEqual(gen_compliance.main(['--root', t.root, '--check']), 1)


if __name__ == '__main__':
    unittest.main()
