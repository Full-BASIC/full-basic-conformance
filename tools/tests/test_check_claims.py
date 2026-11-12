import os, unittest
from helpers import Tree, prog, claim, write
import check_claims


class CheckClaimsTests(unittest.TestCase):
    def setUp(self):
        self.t = Tree()
        self.addCleanup(self.t.cleanup)

    def good(self):
        t = self.t
        t.program('01-a', 'AAA-0001', prog('AAA-0001', 'A-1.1-01', 'SELF', '10 PRINT 1\n'))
        t.claims('ansi-01.yaml', claim())
        t.results({'AAA-0001': 'pass'})

    def errors(self, **kw):
        e, _ = check_claims.check(self.t.root, **kw)
        return e

    def assertHas(self, text):
        e = self.errors()
        self.assertTrue(any(text in x for x in e), f'{text!r} not in {e}')

    def test_consistent_tree_is_clean(self):
        self.good()
        self.assertEqual(self.errors(), [])

    def test_file_name_outside_cwd_is_rejected(self):
        for lit in ('../x.DAT', '/tmp/x.DAT', 'sub/x.DAT', '~/x', 'C:x.DAT', 'a\\b'):
            with self.subTest(lit=lit):
                self.t = Tree()
                self.addCleanup(self.t.cleanup)
                self.t.program('01-a', 'AAA-0001', prog('AAA-0001', 'A-1.1-01', 'SELF',
                               f'10 OPEN #1: NAME "{lit}", ACCESS OUTPUT\n'))
                self.t.claims('ansi-01.yaml', claim())
                self.t.results({'AAA-0001': 'pass'})
                self.assertHas('leaves the working directory')

    def test_file_name_in_cwd_and_rem_text_are_fine(self):
        self.t.program('01-a', 'AAA-0001', prog('AAA-0001', 'A-1.1-01', 'SELF',
                       '10 REM NAME "../x"\n20 OPEN #1: NAME "AAA0001.DAT", ACCESS OUTPUT\n'))
        self.t.claims('ansi-01.yaml', claim())
        self.t.results({'AAA-0001': 'pass'})
        self.assertEqual(self.errors(), [])

    def test_failing_claimed_test(self):
        self.good()
        self.t.results({'AAA-0001': 'fail'})
        self.assertHas('does not pass in results')

    def test_missing_result(self):
        self.good()
        self.t.results({})
        self.assertHas('does not pass in results')

    def test_missing_results_file(self):
        self.good()
        os.remove(self.t.path('results', 'fullbasic.json'))
        self.assertHas('results file not found')

    def test_open_claim_failing_is_accepted(self):
        self.good()
        self.t.claims('ansi-01.yaml', claim(extra='  status: open\n  card: ISSUE-12\n'))
        self.t.results({'AAA-0001': 'fail'})
        self.assertEqual(self.errors(), [])

    def test_open_claim_without_result_is_accepted(self):
        self.good()
        self.t.claims('ansi-01.yaml', claim(extra='  status: open\n  card: ISSUE-12\n'))
        self.t.results({})
        self.assertEqual(self.errors(), [])

    def test_open_claim_that_passes_must_be_promoted(self):
        self.good()
        self.t.claims('ansi-01.yaml', claim(extra='  status: open\n  card: ISSUE-12\n'))
        self.assertHas('marked open but all its tests pass')

    def test_open_requires_card(self):
        self.good()
        self.t.claims('ansi-01.yaml', claim(extra='  status: open\n'))
        self.t.results({'AAA-0001': 'fail'})
        self.assertHas('requires `card')

    def test_card_only_on_open(self):
        self.good()
        self.t.claims('ansi-01.yaml', claim(extra='  card: ISSUE-12\n'))
        self.assertHas('only allowed on open claims')

    def test_bad_status(self):
        self.good()
        self.t.claims('ansi-01.yaml', claim(extra='  status: maybe\n'))
        self.assertHas('status must be one of')

    def test_pending_claim_needs_no_test_nor_value(self):
        self.good()
        self.t.claims('ansi-01.yaml', claim() + claim(id='A-1.1-02', tests='', extra='  status: pending\n') +
                      claim(id='A-1.1-03', kind='implementation-defined', tests='', extra='  status: pending\n'))
        self.assertEqual(self.errors(), [])

    def test_pending_with_passing_tests_must_be_promoted(self):
        self.good()
        self.t.claims('ansi-01.yaml', claim(extra='  status: pending\n'))
        self.assertHas('marked pending but all its tests pass')

    def test_pending_with_failing_test_is_accepted(self):
        self.good()
        self.t.claims('ansi-01.yaml', claim(extra='  status: pending\n'))
        self.t.results({'AAA-0001': 'fail'})
        self.assertEqual(self.errors(), [])

    def test_pending_does_not_accept_card(self):
        self.good()
        self.t.claims('ansi-01.yaml', claim(tests='', extra='  status: pending\n  card: ISSUE-12\n'))
        self.assertHas('only allowed on open claims')

    def test_claimed_without_tests_still_fails(self):
        self.good()
        self.t.claims('ansi-01.yaml', claim(tests='', extra='  status: claimed\n'))
        self.assertHas('at least one test')

    def test_covers_format(self):
        self.good()
        self.t.claims('ansi-01.yaml', claim(extra='  covers: [l.10, l.20-25]\n'))
        self.assertEqual(self.errors(), [])
        for bad in ('[10]', '[l.30-20]', '[l.1-2-3]', '[x.5]'):
            self.t.claims('ansi-01.yaml', claim(extra=f'  covers: {bad}\n'))
            self.assertHas('covers must be a list')

    def test_duplicate_ids(self):
        self.good()
        self.t.claims('ansi-02.yaml', claim())
        self.assertHas('duplicate id')

    def test_claim_without_tests(self):
        self.good()
        self.t.claims('ansi-01.yaml', claim(tests=''))
        self.assertHas('at least one test')

    def test_unknown_test(self):
        self.good()
        self.t.claims('ansi-01.yaml', claim(tests='AAA-0001, AAA-0099'))
        self.assertHas('AAA-0099 has no program')

    def test_orphan_program(self):
        self.good()
        self.t.program('01-a', 'AAA-0002', prog('AAA-0002', 'A-1.1-01', 'SELF', '10 PRINT 1\n'))
        e = self.errors()
        self.assertTrue(any('does not list AAA-0002' in x for x in e))
        self.assertTrue(any('belongs to no claim' in x for x in e))

    def test_header_mismatches(self):
        self.good()
        self.t.program('01-a', 'AAA-0001', prog('AAA-0009', 'A-1.1-01', 'SELF', '10 PRINT 1\n'))
        self.assertHas('must equal the file name')
        self.t.program('01-a', 'AAA-0001', prog('AAA-0001', 'A-1.1-77', 'SELF', '10 PRINT 1\n'))
        self.assertHas('A-1.1-77 is not in claims/')
        self.t.program('01-a', 'AAA-0001', prog('AAA-0001', 'A-1.1-01', 'BOGUS', '10 PRINT 1\n'))
        self.assertHas('REM TYPE')

    def test_type_specific_requirements(self):
        self.good()
        for ttype, text in (('OUTPUT', '.OUT'), ('INPUT', '.IN'), ('GRAPHIC', '.DRAW'), ('FATAL', 'EXPECT'), ('REJECT', 'EXECUTED')):
            self.t.program('01-a', 'AAA-0001', prog('AAA-0001', 'A-1.1-01', ttype, '10 PRINT 1\n'))
            self.assertHas(text)

    def test_not_applicable_needs_reason(self):
        self.good()
        self.t.claims('ansi-01.yaml', claim(kind='not-applicable'))
        self.assertHas('requires a `reason`')
        self.t.claims('ansi-01.yaml', claim(kind='not-applicable', extra='  reason: "Out of scope."\n'))
        self.assertEqual(self.errors(), [])

    def test_implementation_defined_needs_value(self):
        self.good()
        self.t.claims('ansi-01.yaml', claim(kind='implementation-defined'))
        self.assertHas('requires a `value`')
        self.t.claims('ansi-01.yaml', claim(kind='implementation-defined', extra='  value: 15\n'))
        self.assertEqual(self.errors(), [])

    def test_stray_sidecar_and_stale_results(self):
        self.good()
        write(self.t.path('programs', '01-a', 'AAA-0005.OUT'), 'x\n')
        self.t.results({'AAA-0001': 'pass', 'ZZZ-0001': 'pass'})
        e = self.errors()
        self.assertTrue(any('no matching AAA-0005.BAS' in x for x in e))
        self.assertTrue(any('ZZZ-0001 is not a program' in x for x in e))

    def test_unparseable_yaml_is_reported(self):
        self.good()
        self.t.claims('ansi-02.yaml', 'a: 1\n')
        self.assertHas('cannot parse')

    def test_eight_word_rule(self):
        self.good()
        std = self.t.path('std.md')
        write(std, 'The quick brown fox jumps over the lazy dog near the river bank today.\n')
        long_copy = 'We note that the quick brown fox jumps over the lazy dog near here.'   # 9+ shared words
        self.t.claims('ansi-01.yaml', claim(claim=long_copy))
        e, _ = check_claims.check(self.t.root, standard=std)
        self.assertTrue(any('consecutive' in x for x in e), e)
        self.t.claims('ansi-01.yaml', claim(claim='We note the quick brown fox jumps over the lazy cat.'))  # 8 shared words
        e, _ = check_claims.check(self.t.root, standard=std)
        self.assertEqual(e, [])

    def test_internal_references_are_rejected(self):
        cases = [
            ('claim', claim(extra='  note: "Fixed in TR12 (finding 6-H4)."\n'), '10 PRINT 1\n'),
            ('reading', claim(claim='See Docs/estado/deuda.md for this.'), '10 PRINT 1\n'),
            ('rem', claim(), '10 REM decided in Nucleo E41, see vm.cpp\n20 PRINT 1\n'),
            ('bang', claim(), '10 PRINT 1 ! card TC6.4a\n'),
        ]
        for label, yaml_text, body in cases:
            with self.subTest(label):
                self.t = Tree()
                self.addCleanup(self.t.cleanup)
                self.t.program('01-a', 'AAA-0001', prog('AAA-0001', 'A-1.1-01', 'SELF', body))
                self.t.claims('ansi-01.yaml', yaml_text)
                self.t.results({'AAA-0001': 'pass'})
                self.assertHas('internal reference')

    def test_claim_ids_and_cards_are_not_internal_references(self):
        self.t.program('01-a', 'AAA-0001', prog('AAA-0001', 'A-4.2.2-TR153', 'SELF',
                       '10 REM same rule as A-9.2.4.1-TR146B and claim D-10.3-2\n20 PRINT 1\n'))
        self.t.claims('ansi-01.yaml', claim(id='A-4.2.2-TR153', claim='As in A-9.2.4.1-TR146B, UTF-8 and l.1337.'))
        self.t.results({'AAA-0001': 'pass'})
        self.assertEqual(self.errors(), [])

    def test_missing_standard_is_a_note(self):
        self.good()
        e, notes = check_claims.check(self.t.root)
        self.assertEqual(e, [])
        self.assertTrue(any('8-word rule was not checked' in n for n in notes))


if __name__ == '__main__':
    unittest.main()
