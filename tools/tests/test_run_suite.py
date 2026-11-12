import json, os, shutil, sys, unittest
from helpers import Tree, prog, write, HERE
import run_suite
from run_suite import evaluate

def R(rc=0, out='', err='', timeout=False):
    return dict(rc=rc, stdout=out, stderr=err, timeout=timeout)


class EvaluateTests(unittest.TestCase):
    def test_self(self):
        self.assertEqual(evaluate('SELF', {}, '', R(out='x\n*** TEST PASSED ***\n'))[0], 'pass')
        self.assertEqual(evaluate('SELF', {}, '', R(out='x\n'))[0], 'fail')
        self.assertEqual(evaluate('SELF', {}, '', R(out='*** TEST PASSED ***\n*** TEST FAILED: z\n'))[0], 'fail')
        self.assertEqual(evaluate('SELF', {}, '', R(rc=1, out='*** TEST PASSED ***\n'))[0], 'fail')
        self.assertEqual(evaluate('SELF', {}, '', R(timeout=True))[0], 'fail')

    def test_output_ignores_trailing_blanks(self):
        self.assertEqual(evaluate('OUTPUT', {}, '', R(out='A  \nB\n\n'), oracle_out='A\nB')[0], 'pass')
        self.assertEqual(evaluate('OUTPUT', {}, '', R(out='A\nC\n'), oracle_out='A\nB')[0], 'fail')
        self.assertEqual(evaluate('OUTPUT', {}, '', R(out='A\n'))[0], 'fail')

    def test_input_with_oracle_behaves_as_output(self):
        self.assertEqual(evaluate('INPUT', {}, '', R(out='5\n'), oracle_out='5\n')[0], 'pass')
        self.assertEqual(evaluate('INPUT', {}, '', R(out='*** TEST PASSED ***\n'))[0], 'pass')

    def test_reject(self):
        self.assertEqual(evaluate('REJECT', {}, '', R(rc=1, err='bad'))[0], 'pass')
        self.assertEqual(evaluate('REJECT', {}, '', R(rc=1, out='EXECUTED\n'))[0], 'fail')
        self.assertEqual(evaluate('REJECT', {}, '', R(rc=0))[0], 'fail')

    def test_reject_with_expected_diagnostic(self):
        # When the diagnostic is known, rejecting for ANOTHER reason is not a pass.
        ev = lambda r, exp: evaluate('REJECT', {}, '', r, expect_reject=exp)[0]
        self.assertEqual(ev(R(rc=1, err='ERROR E-TYPE-MISMATCH: line 4'), 'E-TYPE-MISMATCH'), 'pass')
        self.assertEqual(ev(R(rc=1, err='ERROR E-LINE-TOO-LONG: line 4'), 'E-TYPE-MISMATCH'), 'fail')
        self.assertEqual(ev(R(rc=1, err='ERROR E-TYPE-MISMATCH-2: x'), 'E-TYPE-MISMATCH'), 'fail')
        self.assertEqual(ev(R(rc=1, out='ERROR 9000: x'), '9000'), 'pass')
        self.assertEqual(ev(R(rc=1, err='ERROR E-LINE-TOO-LONG'), None), 'pass')
        st, detail = evaluate('REJECT', {}, '', R(rc=1, err='ERROR E-LINE-TOO-LONG'), expect_reject='E-X')
        self.assertIn('E-X', detail)

    def test_fatal_and_warn(self):
        hdr = {'EXPECT': '3001 120'}
        self.assertEqual(evaluate('FATAL', hdr, '', R(rc=1, err='ERROR 3001: line 120 - x'))[0], 'pass')
        self.assertEqual(evaluate('FATAL', hdr, '', R(rc=1, err='ERROR 3001: line 121'))[0], 'fail')
        self.assertEqual(evaluate('FATAL', hdr, '', R(rc=1, err='ERROR 13001 line 120'))[0], 'fail')
        self.assertEqual(evaluate('FATAL', hdr, '', R(rc=0, out='3001 120'))[0], 'fail')
        self.assertEqual(evaluate('WARN', hdr, '', R(rc=0, err='WARNING 3001 at 120'))[0], 'pass')
        self.assertEqual(evaluate('WARN', hdr, '', R(rc=1, err='3001 120'))[0], 'fail')
        self.assertEqual(evaluate('FATAL', {}, '', R(rc=1))[0], 'fail')

    def test_graphic(self):
        self.assertEqual(evaluate('GRAPHIC', {}, '', R(), oracle_draw='A', drawlog=None)[0], 'unsupported')
        self.assertEqual(evaluate('GRAPHIC', {}, '', R(), oracle_draw='A\n', drawlog='A  \n')[0], 'pass')
        self.assertEqual(evaluate('GRAPHIC', {}, '', R(), oracle_draw='A', drawlog='B')[0], 'fail')


FAKE = '''import sys, os
src = open(sys.argv[1]).read()
assert os.listdir('.') == [sys.argv[1]], os.listdir('.')   # empty dir + the program only
if 'BOOM' in src:
    sys.stderr.write('ERROR 1005: line 10 - x\\n'); sys.exit(1)
if 'HANG' in src:
    import time; time.sleep(30)
if len(sys.argv) > 2:
    open(sys.argv[2], 'w').write('DRAW_POINTS (1,1)\\n')
print('*** TEST PASSED ***')
'''


class RunSuiteTests(unittest.TestCase):
    def setUp(self):
        self.t = Tree()
        self.addCleanup(self.t.cleanup)
        fake = os.path.join(self.t.root, 'fake.py')
        write(fake, FAKE)
        self.fake = fake

    def template(self, draw=False):
        return f'{sys.executable} {self.fake} {{file}}' + (' {drawlog}' if draw else '')

    def test_files_written_by_programs_do_not_survive_the_run(self):
        import tempfile
        writer = os.path.join(self.t.root, 'writer.py')
        write(writer, "open('LEFT.DAT','w').write('x')\nprint('*** TEST PASSED ***')\n")
        self.t.program('01-a', 'AAA-0001', prog('AAA-0001', 'A-1.1-01', 'SELF', '10 PRINT 1\n'))
        scratch = tempfile.mkdtemp(prefix='fbcs-scratch-')
        self.addCleanup(shutil.rmtree, scratch, True)
        old, tempfile.tempdir = tempfile.tempdir, scratch      # private temp root: no interference from others
        self.addCleanup(setattr, tempfile, 'tempdir', old)
        cwd = os.getcwd()
        data = run_suite.run_suite(self.t.root, f'{sys.executable} {writer} {{file}}', 'x', jobs=1)
        self.assertEqual(data['summary']['pass'], 1)
        self.assertEqual(os.getcwd(), cwd)
        self.assertEqual(os.listdir(scratch), [])                             # temp cwd removed
        found = [f for _, _, fs in os.walk(self.t.root) for f in fs if f == 'LEFT.DAT']
        self.assertEqual(found, [])                                           # nothing in the tree

    def test_mixed_suite(self):
        t = self.t
        t.program('01-a', 'AAA-0001', prog('AAA-0001', 'X', 'SELF', '10 PRINT 1\n'))
        t.program('01-a', 'AAA-0002', prog('AAA-0002', 'X', 'FATAL', '10 REM BOOM\n', '4 REM EXPECT 1005 10\n'))
        t.program('01-a', 'AAA-0003', prog('AAA-0003', 'X', 'SELF', '10 REM HANG\n'))
        t.program('01-a', 'AAA-0004', prog('AAA-0004', 'X', 'GRAPHIC', '10 PRINT 1\n'), draw='DRAW_POINTS (1,1)\n')
        data = run_suite.run_suite(t.root, self.template(), 'fake', timeout=1.5)
        st = {k: v['status'] for k, v in data['results'].items()}
        self.assertEqual(st, {'AAA-0001': 'pass', 'AAA-0002': 'pass', 'AAA-0003': 'fail', 'AAA-0004': 'unsupported'})
        self.assertEqual(data['results']['AAA-0003']['detail'], 'timeout')
        self.assertEqual(data['summary'], {'pass': 2, 'fail': 1, 'unsupported': 1})
        data = run_suite.run_suite(t.root, self.template(draw=True), 'fake', timeout=1.5, only=['AAA-0004'])
        self.assertEqual(data['results']['AAA-0004']['status'], 'pass')

    def test_main_writes_output_and_exit_code(self):
        t = self.t
        t.program('01-a', 'AAA-0001', prog('AAA-0001', 'X', 'SELF', '10 PRINT 1\n'))
        out = t.path('results', 'x.json')
        rc = run_suite.main(['--root', t.root, '--interpreter', self.template(), '--output', out, '--name', 'fake'])
        self.assertEqual(rc, 0)
        with open(out) as f:
            self.assertEqual(json.load(f)['results']['AAA-0001']['status'], 'pass')
        t.program('01-a', 'AAA-0002', prog('AAA-0002', 'X', 'SELF', '10 REM BOOM\n'))
        self.assertEqual(run_suite.main(['--root', t.root, '--interpreter', self.template(), '--only', 'AAA-0002']), 1)

    def test_bad_interpreter_is_a_failure_not_a_crash(self):
        self.t.program('01-a', 'AAA-0001', prog('AAA-0001', 'X', 'SELF', '10 PRINT 1\n'))
        data = run_suite.run_suite(self.t.root, '/nonexistent/interp {file}', 'x')
        self.assertEqual(data['results']['AAA-0001']['status'], 'fail')

    def test_input_file_is_fed_to_stdin(self):
        t = self.t
        write(os.path.join(t.root, 'cat.py'), 'import sys\nprint(sys.stdin.read().strip())\n')
        t.program('01-a', 'AAA-0001', prog('AAA-0001', 'X', 'INPUT', '10 INPUT A\n'), **{'in': '42\n', 'out': '42\n'})
        data = run_suite.run_suite(t.root, f'{sys.executable} {t.root}/cat.py {{file}}', 'x')
        self.assertEqual(data['results']['AAA-0001']['status'], 'pass')


BIN = os.environ.get('FULLBASIC_BIN') or os.path.join(
    os.environ.get('XDEV_DERIVED', '/tmp/FullBASIC_build'), 'Build/Products/Debug/FullBasicCore')


@unittest.skipUnless(os.access(BIN, os.X_OK), 'FullBasicCore CLI not found (set FULLBASIC_BIN to its path)')
class RejectMapTests(unittest.TestCase):
    def test_reject_codes_file_is_enforced_and_complete(self):
        t = Tree()
        self.addCleanup(t.cleanup)
        write(os.path.join(t.root, 'rej.py'),
              'import sys\ncode = "E-B" if "REM B" in open(sys.argv[1]).read() else "E-A"\n'
              'sys.stderr.write("ERROR " + code + ": x\\n")\nsys.exit(1)\n')
        t.program('01-a', 'AAA-0001', prog('AAA-0001', 'X', 'REJECT', '10 REM A\n'))
        t.program('01-a', 'AAA-0002', prog('AAA-0002', 'X', 'REJECT', '10 REM B\n'))
        t.program('01-a', 'AAA-0003', prog('AAA-0003', 'X', 'REJECT', '10 REM C\n'))
        codes = os.path.join(t.root, 'codes.json')
        write(codes, json.dumps({'AAA-0001': 'E-A', 'AAA-0002': 'E-A'}))   # AAA-0002 really prints E-B
        data = run_suite.run_suite(t.root, f'{sys.executable} {t.root}/rej.py {{file}}', 'x', reject_codes=run_suite.load_reject_codes(codes))
        st = {k: v['status'] for k, v in data['results'].items()}
        self.assertEqual(st['AAA-0001'], 'pass')
        self.assertEqual(st['AAA-0002'], 'fail')   # rejected, but for another reason
        self.assertIn('E-A', data['results']['AAA-0002']['detail'])
        self.assertEqual(st['AAA-0003'], 'fail')
        self.assertIn('no expected diagnostic', data['results']['AAA-0003']['detail'])


class PublishedSuiteTests(unittest.TestCase):
    """Static checks on the published programs (no interpreter needed)."""
    ROOT = os.path.dirname(os.path.dirname(HERE))

    def test_every_reject_program_has_an_expected_diagnostic(self):
        import fbcs
        codes = run_suite.load_reject_codes(os.path.join(self.ROOT, 'reject-codes-fullbasic.json'))
        rejects = set()
        for pid, path in fbcs.program_files(self.ROOT).items():
            with open(path, encoding='utf-8', errors='replace') as f:
                if (fbcs.parse_header(f.read()).get('TYPE') or '').upper() == 'REJECT':
                    rejects.add(pid)
        self.assertEqual(rejects - set(codes), set())
        self.assertEqual(set(codes) - rejects, set())

    def test_only_the_line_length_test_has_lines_over_132(self):
        import fbcs
        over = {}
        for pid, path in fbcs.program_files(self.ROOT).items():
            with open(path, encoding='utf-8', errors='replace', newline='') as f:
                n = [len(l.rstrip('\r\n')) for l in f.read().split('\n')]
            if max(n or [0]) > 132:
                over[pid] = max(n)
        self.assertEqual(sorted(over), ['PRG-0033'], over)


@unittest.skipUnless(os.access(BIN, os.X_OK), 'FullBasicCore CLI not found (set FULLBASIC_BIN to its path)')
class CliDrawLogTests(unittest.TestCase):
    """--draw-log of the real CLI: GRAPHIC tests run without Xcode."""

    def test_graphic_program_against_hand_written_oracle(self):
        t = Tree()
        self.addCleanup(t.cleanup)
        body = '10 SET WINDOW 0, 1, 0, 1\n20 PLOT LINES: 0, 0; 1, 1\n30 END\n'
        t.program('13-graphics', 'GRA-0001', prog('GRA-0001', 'X', 'GRAPHIC', body),
                  draw='SET_WINDOW 0 1 0 1\nDRAW_LINES (0,0) (1,1)\n')
        data = run_suite.run_suite(t.root, f'{BIN} --draw-log {{drawlog}} {{file}}', 'cli')
        self.assertEqual(data['results']['GRA-0001']['status'], 'pass', data)
        data = run_suite.run_suite(t.root, f'{BIN} {{file}}', 'cli')
        self.assertEqual(data['results']['GRA-0001']['status'], 'unsupported')


if __name__ == '__main__':
    unittest.main()
