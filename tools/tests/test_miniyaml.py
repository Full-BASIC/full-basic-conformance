import os, sys, unittest
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
import miniyaml
from miniyaml import MiniYamlError, loads


class MiniYamlTests(unittest.TestCase):
    def test_empty_and_comments(self):
        self.assertEqual(loads(''), [])
        self.assertEqual(loads('# only a comment\n\n'), [])

    def test_basic_record(self):
        doc = '''- id: A-9.2.4.1-01
  clause: "9.2.4.1"   # comment
  claim: 'it''s here'
  tests: [SEG-0142, "X, Y", 'Z']
  external: []
  card: null
'''
        self.assertEqual(loads(doc), [{
            'id': 'A-9.2.4.1-01', 'clause': '9.2.4.1', 'claim': "it's here",
            'tests': ['SEG-0142', 'X, Y', 'Z'], 'external': [], 'card': None}])

    def test_scalars(self):
        r = loads('- a: 12\n  b: true\n  c: false\n  d: ~\n  e:\n  f: "12"\n  g: some text here\n')[0]
        self.assertEqual(r, {'a': 12, 'b': True, 'c': False, 'd': None, 'e': None, 'f': '12', 'g': 'some text here'})

    def test_hash_inside_quotes_is_not_comment(self):
        self.assertEqual(loads('- a: "x # y"\n')[0]['a'], 'x # y')

    def test_two_records_and_escapes(self):
        r = loads('- id: a\n  claim: "q\\"uote\\n"\n- id: b\n')
        self.assertEqual(r, [{'id': 'a', 'claim': 'q"uote\n'}, {'id': 'b'}])

    def test_rejects(self):
        bad = {
            'top-level mapping': 'a: 1\n',
            'nested mapping': '- a:\n    b: 1\n',
            'block scalar': '- a: |\n  text\n',
            'folded scalar': '- a: >\n  text\n',
            'anchor': '- a: &x 1\n',
            'alias': '- a: *x\n',
            'flow map': '- a: {b: 1}\n',
            'tab': '- a:\t1\n',
            'duplicate key': '- a: 1\n  a: 2\n',
            'doc marker': '---\n- a: 1\n',
            'unterminated string': '- a: "abc\n',
            'unclosed list': '- a: [1, 2\n',
            'nested list': '- a: [1, [2]]\n',
            'bad indent': '- a: 1\n    b: 2\n',
            'trailing comma': '- a: [1, ]\n',
            'bad escape': '- a: "\\u1234"\n',
            'not key value': '- just text\n',
            'indented dash': '  - a: 1\n',
        }
        for name, doc in bad.items():
            with self.subTest(name):
                with self.assertRaises(MiniYamlError) as cm:
                    loads(doc)
                self.assertIn('line', str(cm.exception))


if __name__ == '__main__':
    unittest.main()
