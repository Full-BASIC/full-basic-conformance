# FBCS: Full BASIC Conformance Suite

An interpreter-independent conformance suite for ANSI X3.113-1987 Full BASIC
(FIPS PUB 68-2), in the style of the NBS Minimal BASIC test programs. Each
statement the suite makes about the language is a **claim**; each claim points to
one or more small BASIC **programs** that decide it, and a **runner** executes
them against any interpreter.

The suite never quotes the standard beyond 8 consecutive words (checked by
`tools/check_claims.py`); claims are written in our own words and cite the clause.

## Layout

```text
claims/ansi-NN.yaml            claims per chapter of the standard
claims/implementation-defined.yaml
interpretations.yaml           agreed readings of the standard, rendered in section 4
programs/NN-area/AAA-0000.BAS  test programs (+ .OUT, .IN, .DRAW per type)
results/fullbasic.json         last published run (written by run_suite.py)
reject-codes-fullbasic.json    expected diagnostic of each REJECT program (run_suite.py --reject-codes)
tools/                         run_suite.py, check_claims.py, gen_compliance.py, miniyaml.py
COMPLIANCE_ANSI.md             generated, claims that pass
COMPLIANCE_ECMA.md             generated, same claims by ECMA-116 clause
LICENSE                        MIT (see below)
```

## Running it

Python 3 standard library only; no packages to install.

```bash
# run every program with your interpreter; {file} is the program, in the cwd
python3 tools/run_suite.py --interpreter 'myinterp {file}' --name 'MyInterp 1.0' \
        --output results/myinterp.json
# add {drawlog} to also run GRAPHIC tests (see below)
python3 tools/run_suite.py --interpreter 'myinterp --draw-log {drawlog} {file}'

python3 tools/check_claims.py            # claims, programs and results agree
python3 tools/gen_compliance.py          # regenerate the two COMPLIANCE_*.md
python3 tools/gen_compliance.py --check  # CI: fail if they are out of date
python3 -m unittest discover -s tools/tests
```

Every program runs in its own **empty temporary directory** with the program copied
in as `<ID>.BAS`. `run_suite.py` exits 1 if any test fails. The published results come
from FullBASIC v4, run as `--interpreter 'FullBasicCore --draw-log {drawlog} {file}'
--reject-codes reject-codes-fullbasic.json` (the exact commands are in section 2 of the
generated documents).

A bare `REJECT` test passes for any rejection, even one for another reason (for example
a physical line over 132 characters). Diagnostic identifiers are interpreter-specific, so
the portable programs carry none; with `--reject-codes FILE` (JSON `{program id:
diagnostic}`) a REJECT program passes only if the output reports that diagnostic, and a
REJECT program missing from the file fails. `reject-codes-fullbasic.json` is the map for
FullBASIC v4 (a unit test requires one entry per REJECT program).

To check your own results against the claims, pass `--results` to `check_claims.py`.
To adapt the suite to another interpreter you only need a command line that runs a
program and (for the optional types) reports errors and graphic primitives as below.

## Test types

Every program starts with a header read by the runner:

```basic
1 REM FBCS SEG-0142
2 REM CLAIM A-9.2.4.1-01
3 REM TYPE SELF
```

`FBCS` equals the file name, `CLAIM` is the claim the program belongs to. The type
decides what passes:

| Type | Passes when | Extra |
|---|---|---|
| `SELF` | prints a line `*** TEST PASSED ***`, no line starting `*** TEST FAILED`, exit code 0, terminates in time | default type |
| `OUTPUT` | stdout equals `<ID>.OUT` (trailing blanks and trailing empty lines ignored), exit code 0 | `.OUT` |
| `REJECT` | exit code is not 0 and `EXECUTED` is never printed | the program prints `EXECUTED` before the non-conforming construct, so a load-time rejection is told apart from a run-time failure |
| `FATAL` | exit code is not 0 and stdout+stderr contain the exception code and the line number, as whole numbers | header `REM EXPECT <code> <line>` |
| `WARN` | exit code is 0 and the output contains the code and line | header `REM EXPECT <code> <line>` |
| `INPUT` | stdin is `<ID>.IN`; then judged as `SELF`, or as `OUTPUT` when `<ID>.OUT` exists | `.IN` |
| `GRAPHIC` | the primitives written to `{drawlog}` equal `<ID>.DRAW` | `.DRAW`, template with `{drawlog}`. Without `{drawlog}` the result is `unsupported`: not a failure, not a pass |

A catchable exception is checked from inside the program (see `programs/07-arrays/ARR-0031.BAS`).

## Authoring rules for programs that report exceptions

* The text of an exception report (the wording, layout and numbering of the message an
  interpreter prints for a nonfatal or fatal exception, e.g. `Warning 4005: line 110 ...`)
  is implementation-specific. It must never appear in a `.OUT` oracle. A `WARN` or
  `FATAL` program is judged only by exit code, code and line number (`REM EXPECT`) and has
  no `.OUT`; `run_suite.py` ignores a `.OUT` next to such a program.
* To check the values a statement produced while it raised a nonfatal exception, make the
  program `SELF` and read the effect back from inside the program (for example print to a
  file and read the file back), and put the report check in a separate `WARN` program.
  An `OUTPUT` program is for output that no exception report accompanies.

## Authoring rules for programs that touch files

* Every program runs in its own empty cwd (`run_suite.py` creates it and deletes it
  afterwards). Name only files in that directory: no `/`, `\`, `..`, `~` or drive prefix in a
  `NAME "..."` literal. `check_claims.py` reports any such literal.
* Use file names unique to the program (derive them from the id, e.g. `FIL0151.DAT`).
  Isolation makes shared names harmless under `run_suite.py`, but a name unique to the
  program stays safe when someone runs several programs in one directory.
* Never run a program by hand with the program directory as cwd: the files it writes
  (`.DAT`, `.tmp`, `t.txt`...) stay there and make `check_claims.py` fail with
  "unexpected file". Run it with `run_suite.py ... --only ID`, or copy it to an empty
  directory first. Delete leftovers before trusting a result: a program that opens a file
  `ACCESS OUTIN` passes or fails depending on whether the file already exists (an existing
  file gives 7308, so a stale one can hide or fake a result).
* A physical line is at most 132 characters, header (`REM FBCS`, `REM CLAIM`, ...)
  included; a longer one is rejected by the loader (E-LINE-TOO-LONG) before the program
  runs. Only the REJECT program that tests exactly that may exceed it.

## Claims

`claims/*.yaml` hold one record per claim:

```yaml
- id: A-9.2.4.1-01
  clause: "9.2.4.1"
  ecma: null              # ECMA-116 clause, or null
  module: core            # core | files | graphics | fixed
  kind: semantics         # syntax | semantics | exception | implementation-defined | not-applicable
  claim: "An array element given as a subprogram argument is passed by reference."
  tests: [SEG-0142]
  external: []            # evidence not published here, e.g. NBS:P101
  status: open            # optional: claimed (default) | open | pending
  card: ISSUE-12          # required when status is open
  covers: [l.3164, l.3170-3172]   # optional: lines of the standard text the claim answers
  note: "..."             # optional free text (e.g. a finding that qualifies the claim)
  reason: "..."           # required for not-applicable
  value: "..."            # required for implementation-defined
```

### Claimed and open claims

* `status: claimed` (the default): all its tests must pass in `results/fullbasic.json`.
  Only claimed claims whose tests pass appear in the `COMPLIANCE_*.md` documents.
* `status: open` with `card: <work item>`: a **known failure** that is tracked, not
  claimed. Its programs must exist and be valid, but they must not all pass (if they
  do, `check_claims.py` asks you to promote the claim). Open claims are never listed
  in the generated documents; only their count is shown. Failing results are recorded
  honestly in `results/`, never as passing.

* `status: pending`: the claim was inventoried from the standard but **no test passes it
  yet** (`tests: []`, or tests that fail or are not written). It needs no `card`, and an
  implementation-defined pending claim needs no `value` yet. Pending claims are never
  listed in the generated documents; only their count is shown. If every test a pending
  claim lists passes, `check_claims.py` asks you to make it `claimed`. A claim without
  tests that is not `pending` (and not `not-applicable`) is an error.

Claim ids: `A-<clause>-<nn>` for rules of the text, `E-<code>` for an exception code of
Table 9 (`E-1005-F` for a variant under fixed decimal), `D-<clause>-<n>` for an item of
Appendix C (implementation-defined features) of that clause.

`covers` ties a claim to the lines of the standard's text that it answers. The line
numbers (`l.N`, also used in claims, notes and program comments) refer to a Markdown
transcription of FIPS PUB 68-2 that is not distributed with the suite; the ECMA-116
claims cite a transcription of that standard in the same way. The maintainers use
`covers` to check that every candidate statement of the standard (each line with a
normative "shall", each exception, each Examples section) is covered by a claim or
discarded with a reason. The tools in this tree do not need it.

### `check_claims.py` rules

It fails if: a claim has no test (not-applicable claims carry a `reason`;
implementation-defined ones a `value` and a test; pending claims need neither); a test id has no program; a
program belongs to no claim or its header disagrees with the registry; ids are not
unique; a claimed test does not pass; an open or pending claim fully passes; `covers` is
not a list of `l.N` / `l.N-M`; the results name an
unknown program; a program names a file outside its working directory; or a `claim` text copies more than 8 consecutive words from the
standard (this last rule needs the transcription of the standard, given with
`--standard FILE`; without it the rule is skipped and a note says so).

## The YAML subset

The tools use only the standard library, so `tools/miniyaml.py` parses the following
subset and rejects anything else with a line number: a list of mappings
(`- key: value`, continuation keys indented two spaces); plain, `"double"` and
`'single'` quoted scalars; `true`/`false`/`null`/integers; inline lists of scalars
(`[a, "b, c"]`); `#` comments. Not supported: nested mappings, block lists under a
key, block scalars (`|`, `>`), anchors, tags, flow mappings, multi-line scalars, tabs.

## License

The suite (claims, programs, tools and documents) is released under the MIT License; see
`LICENSE`. The standards it refers to are not part of it.
