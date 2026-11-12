#!/usr/bin/env python3
"""Minimal YAML subset parser for Compliance/claims/*.yaml (standard library only).

Supported subset (anything else raises MiniYamlError with the line number):

  * A document is a list of mappings:   "- key: value" followed by
    "  key: value" lines indented to the column of the first key.
  * Scalars: plain (unquoted), "double quoted" (escapes \\\\ \\" \\n \\t),
    'single quoted' ('' is a quote). Plain scalars true/false -> bool,
    null/~/empty -> None, decimal integers -> int; everything else is a string.
  * Inline lists of scalars:  [a, "b, c", 'd']   (may be empty: [])
  * Comments: full lines starting with '#', or ' #' after a plain/quoted value.
  * Blank lines are ignored.

Not supported (rejected): nested mappings, block lists under a key, block scalars
(| and >), anchors/aliases/tags, flow mappings {..}, multi-line scalars, tabs,
documents markers (---), duplicate keys, top-level mappings.
"""
import re
import sys


class MiniYamlError(ValueError):
    pass


_INT = re.compile(r'^[+-]?\d+$')
_KEY = re.compile(r'^([A-Za-z_][A-Za-z0-9_-]*):(?:\s+(.*))?$')


def _err(n, msg):
    raise MiniYamlError(f'line {n}: {msg}')


def _parse_quoted(s, i, n):
    """s[i] is a quote char. Returns (string, index after closing quote)."""
    q = s[i]
    i += 1
    out = []
    while i < len(s):
        c = s[i]
        if q == '"' and c == '\\':
            if i + 1 >= len(s):
                _err(n, 'dangling backslash')
            e = s[i + 1]
            m = {'\\': '\\', '"': '"', 'n': '\n', 't': '\t'}
            if e not in m:
                _err(n, f'unsupported escape \\{e}')
            out.append(m[e])
            i += 2
        elif q == "'" and c == "'":
            if i + 1 < len(s) and s[i + 1] == "'":
                out.append("'")
                i += 2
            else:
                return ''.join(out), i + 1
        elif q == '"' and c == '"':
            return ''.join(out), i + 1
        else:
            out.append(c)
            i += 1
    _err(n, 'unterminated quoted string (multi-line scalars are not supported)')


def _plain(text, n, stop=''):
    text = text.strip()
    if text[:1] in ('|', '>'):
        _err(n, 'block scalars are not supported')
    if text[:1] in ('&', '*', '!', '{', '%', '@', '`'):
        _err(n, f'unsupported YAML syntax starting with {text[0]!r}')
    if text in ('', '~') or text == 'null':
        return None
    if text == 'true':
        return True
    if text == 'false':
        return False
    if _INT.match(text):
        return int(text)
    return text


def _strip_comment(s):
    """Remove a trailing ' #...' comment that is outside quotes."""
    q = None
    for i, c in enumerate(s):
        if q:
            if c == q:
                q = None
        elif c in ('"', "'") and (i == 0 or s[i - 1] in ' [,'):
            q = c
        elif c == '#' and (i == 0 or s[i - 1] in ' \t'):
            return s[:i].rstrip()
    return s


def _parse_value(raw, n):
    s = _strip_comment(raw.strip())
    if s.startswith('['):
        return _parse_inline_list(s, n)
    if s[:1] in ('"', "'"):
        val, j = _parse_quoted(s, 0, n)
        if s[j:].strip():
            _err(n, 'unexpected text after quoted string')
        return val
    return _plain(s, n)


def _parse_inline_list(s, n):
    if not s.endswith(']'):
        _err(n, 'inline list must close with ] on the same line')
    body = s[1:-1]
    items = []
    i = 0
    L = len(body)
    while True:
        while i < L and body[i] == ' ':
            i += 1
        if i >= L:
            break
        if body[i] in ('"', "'"):
            val, i = _parse_quoted(body, i, n)
            while i < L and body[i] == ' ':
                i += 1
            if i < L and body[i] != ',':
                _err(n, 'expected , after quoted list item')
        else:
            j = body.find(',', i)
            j = L if j < 0 else j
            tok = body[i:j]
            if any(ch in tok for ch in '[]{}"\''):
                _err(n, 'nested structures or stray quotes in inline list are not supported')
            val = _plain(tok, n)
            i = j
        items.append(val)
        if i < L and body[i] == ',':
            i += 1
            if not body[i:].strip():
                _err(n, 'trailing comma in inline list')
    return items


def loads(text):
    """Parse text; returns a list of dicts."""
    if '\t' in text:
        n = text[:text.index('\t')].count('\n') + 1
        _err(n, 'tabs are not supported')
    records = []
    cur = None
    key_indent = None
    for n, line in enumerate(text.split('\n'), 1):
        if not line.strip() or line.lstrip().startswith('#'):
            continue
        if line.startswith('---') or line.startswith('...'):
            _err(n, 'document markers are not supported')
        indent = len(line) - len(line.lstrip(' '))
        body = line.strip()
        if body.startswith('- ') or body == '-':
            if indent != 0:
                _err(n, 'nested lists are not supported (list items must start at column 0)')
            rest = body[2:].strip() if body != '-' else ''
            cur = {}
            records.append(cur)
            key_indent = 2
            body, indent = rest, 2
            if not body:
                _err(n, "expected 'key: value' after '- '")
        elif cur is None:
            _err(n, 'top level must be a list of mappings ("- key: value")')
        elif indent != key_indent:
            _err(n, f'expected indentation of {key_indent} spaces for a key, found {indent} '
                    '(nested mappings and multi-line values are not supported)')
        m = _KEY.match(_strip_comment(body))
        if not m:
            _err(n, f'expected "key: value", got {body!r}')
        key, raw = m.group(1), m.group(2)
        if key in cur:
            _err(n, f'duplicate key {key!r}')
        cur[key] = _parse_value(raw, n) if raw is not None else None
    return records


def load(path):
    with open(path, encoding='utf-8') as f:
        try:
            return loads(f.read())
        except MiniYamlError as e:
            raise MiniYamlError(f'{path}: {e}') from None


if __name__ == '__main__':
    import json
    print(json.dumps(load(sys.argv[1]), indent=2, ensure_ascii=False))
