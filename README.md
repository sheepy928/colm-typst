# COLM in Typst (unofficial)

> [!WARNING]
> **Unofficial and not endorsed by or affiliated with COLM. Do not use this
> template for conference submissions or camera-ready papers.** COLM's
> [2026 instructions](https://github.com/COLM-org/Template/blob/2026/colm2026_conference.tex)
> require LaTeX and the official style files. Use the
> [official COLM template](https://github.com/COLM-org/Template/releases/tag/2026)
> for the conference. This project is for personal drafts, experimentation,
> and studying the layout; visual similarity does not establish compliance.

A self-contained, **unofficial** Typst implementation of the
[COLM 2026 format](https://github.com/COLM-org/Template/releases/tag/2026).
Edit [`main.typ`](main.typ) to write a paper; [`colm.typ`](colm.typ) contains
the reusable style. No Typst packages or network access are needed to compile.

This repository is not currently published on Typst Universe. See
[Typst Universe readiness](#typst-universe-readiness) below.

## Build

Install [Typst CLI](https://github.com/typst/typst/releases) 0.15.1 or newer.
From this directory:

```sh
typst compile --font-path fonts --ignore-system-fonts main.typ paper.pdf
typst compile --font-path fonts --ignore-system-fonts --input mode=preprint main.typ preprint.pdf
typst compile --font-path fonts --ignore-system-fonts --input mode=final main.typ final.pdf
```

Alternatively, `make all` builds all three versions in `build/`; `make watch`
rebuilds the submission PDF when sources change. Set `TYPST=/path/to/typst`
when the executable is not on your PATH.

For the Typst web app, upload this entire directory, including `fonts/`, and
open `main.typ`. Uploaded fonts are discovered automatically. Change the
default value of `mode` in `main.typ` to select a different version.

## Modes

| Mode | Authors and PDF author metadata | Line numbers | Running header |
| --- | --- | --- | --- |
| `submission` (default) | Omitted; anonymous title block | Continuous | Under review as a conference paper at COLM 2026 |
| `preprint` | Included | None | Preprint. Under review. |
| `final` | Included | None | Published as a conference paper at COLM 2026 |

These mode names and headers reproduce the reference layout. They do not
indicate submission approval, acceptance, or publication by COLM.

The acknowledgments helper omits its content in submission mode. Pass the
same `mode` to it and to `colm`, as shown in the example. The template cannot
remove identifying information you put in body text, figures, links, citation
entries, the title, or keywords; review those separately when anonymizing.

## Template interface

```typst
#import "colm.typ": colm, colm-appendix, colm-acknowledgments
#let mode = sys.inputs.at("mode", default: "submission")
#show: colm.with(
  title: [Your paper title],
  authors: (
    (name: "First Author",
     affiliation: [Department \ University],
     email: "author@example.edu"),
  ),
  abstract: [A single-paragraph abstract.],
  mode: mode,
)

= Introduction

Your paper starts here.
```

`title` and `abstract` accept Typst content. Each author is a dictionary with
a required string `name`, optional content `affiliation`, optional string
`email`, and optional content `note` for an author footnote. Authors sharing
an affiliation may be grouped in one `name` string. Author notes use symbols;
body footnotes start at 1. `author-columns` defaults to 2 and can be set to 1
for long names or affiliations; more authors wrap onto subsequent rows.

`year` defaults to `2026` and changes the running header; it does not change
the formatting rules. `keywords` accepts an array of strings for PDF metadata.
`sentence-spacing: false` disables the extra space after sentences. The default
approximates TeX's English sentence spacing; use `~` for an explicit nonbreaking
space, such as `Fig.~1`. Code, citations, and bibliography entries retain their
own spacing.

Use ordinary Typst constructs:

- Headings: `= Section`, `== Subsection`, `=== Subsubsection`.
- Unnumbered headings: `#heading(numbering: none)[Ethics statement]`.
- Parenthetical citations: `@vaswani2017`; narrative citations:
  `#cite(<vaswani2017>, form: "prose")`.
- References: `#bibliography("references.bib")`. BibTeX and Hayagriva files work
  with the bundled [`colm.csl`](colm.csl): COLM author–year citations and
  alphabetically ordered references with full given names, sentence-case article
  titles, italic publication titles, and the year after publication details.
- Figures and tables: wrap images or `table(...)` in `figure(...)`, attach
  `caption: [...]`, and use `placement: top` or `placement: bottom` for floats.
  Both kinds have captions below and separate numbering sequences.
- Cross-references: place `<label>` after a heading, figure, or equation and
  cite it with `@label`.
- Acknowledgments: `#colm-acknowledgments(mode: mode)[Your acknowledgments.]`.
- Appendices: place `#show: colm-appendix` after the bibliography, then use
  regular headings. This starts a fresh page and numbers sections A, A.1, B,
  etc., without resetting figures, tables, equations, or page numbers.

## Formatting and fidelity

The implementation is calibrated against the rendered
[official COLM 2026 LaTeX PDF](https://www.overleaf.com/latex/templates/colm-2026-template/wbwzrwczsqvg.pdf)
and its [style file](https://github.com/COLM-org/Template/blob/2026/colm2026_conference.sty).
Sizes below use TeX points (1/72.27 inch), converted to Typst's PDF points
(1/72 inch):

- US Letter, one column, 5.5 × 9 inch text area and 1.5 inch side margins.
  The text area's top is 81.862 PDF points from the page edge, matching the
  effective position produced by LaTeX's header and margin settings.
- 10 pt Palatino-family body text with an 11 pt baseline distance for
  ordinary text, no paragraph indentation, and 6 pt of extra paragraph space.
- Word-space stretch/shrink follows Palatino's LaTeX font metrics: a .25 em
  space can shrink by .06 em or stretch by .15 em. Sentence spaces add .06 em.
  Sentence-ending words stay intact, and single-word paragraph tails are
  discouraged, so the reference's lines 7 and 20 wrap correctly.
- A left-aligned, bold 14.4 pt title on a 16 pt baseline; bold author names;
  a centered 12 pt abstract heading with the abstract inset 36 pt on each side.
- Bold 12 pt section headings, bold 10 pt subsections, and bold italic
  10 pt third-level headings. Spacing includes the paragraph glue visible
  in the reference PDF; numbered headings have a one-em gap after the number.
- Dark blue links; 10 pt code; 9 pt tables and footnotes; a two-inch footnote rule.
- Continuous 6 pt submission line numbers, excluding the title, author block,
  abstract heading, figures/tables, footnotes, and page furniture.

The written instructions and rendered LaTeX PDF disagree in some places,
including the title size and effective top margin. This port follows the PDF:
the LaTeX `\Large` macro produces a 14.4 pt title, despite the prose saying 17 pt.
Typst and TeX use different line breaking, float placement, spacing, and
line-numbering algorithms, so output is not pixel-identical. In particular,
LaTeX stretches vertical glue to fill pages; this port uses the measured
reference spacing without reproducing that stretch on every page. TeX Gyre
Pagella and Pagella Math supply the Palatino-family fonts; the original uses
`mathpazo` for mathematics. References follow the official
[`colm2026_conference.bst`](https://github.com/COLM-org/Template/blob/2026/colm2026_conference.bst),
with a one-em hanging indent, 11 pt baselines, 8 pt between entries, roman DOI
text, and Inconsolata URLs. Font sources and licenses are in
[`fonts/README.md`](fonts/README.md).

The reference port uses Typst's CSL engine. Its supported, checked entry types
are journal articles, conference papers, books, collection chapters, technical
reports, PhD theses, and web resources. Unusual BibTeX types, cross-reference
inheritance, and custom thesis/report types may need manual inspection. CSL
also keeps separate citations when different full author lists share the same
short `et al.` label; natbib can collapse these into one label. Bibliography
year suffixes still distinguish the works.

Page limits are not enforced. The 2026 written instructions specify nine
pages of main text; check the current venue instructions for what counts
toward the limit. Inspect the finished PDF for overflow, long equations,
large floats, and identifying content.

## Validation

The included example has been compiled in all three modes with Typst
0.15.1 using only the bundled and compiler-embedded fonts. Checks cover
author suppression, mode headers, line numbers, citations, and appendices.
Rebuild with `make all` after editing the style.

[`validation/reference.typ`](validation/reference.typ) reproduces the first
page of the official example for spacing comparisons. Its text is attributed
to the original CC BY 4.0 template in the file. The layout check measures
21 text baselines against the LaTeX PDF, along with the header rule, footer,
page size, and line numbers. It also compares the text on **all 32 numbered
lines** with [`reference-lines.json`](validation/reference-lines.json), extracted
from the official PDF. The fixture preserves the source's nonbreaking spaces.
Install the optional `pymupdf` Python package,
then run:

```sh
make check-layout
```

This catches spacing and line-break drift even when compilation succeeds.
It checks the reference page's vertical geometry and line contents, normalizing
PDF whitespace, drawn underscores, and the composed LaTeX logo. It does not
assert identical glyph positions, microtype font expansion, or pagination
for arbitrary papers.

`make check-references` checks ten fixture references against text generated by
BibTeX with the official COLM `.bst`, including its example Transformer entry.
The expected snapshot records the source URL and SHA-256. The check also tests
citation order and punctuation, full names, year suffixes, DOI/URL rendering,
italics, hanging indents, baseline/entry spacing, and citation links. It uses
the same optional `pymupdf` dependency as `check-layout`.

## Licensing status

The original implementation does not yet have a project license. Public
availability on GitHub is not a license grant; a suitable license must be
chosen before a Typst Universe submission. Third-party material retains its
existing terms: bundled fonts have licenses in [`fonts/`](fonts/README.md),
and `validation/reference.typ` and `validation/reference-lines.json` attribute
their adapted COLM example text to Yoav Artzi and the COLM template contributors
under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).

## Typst Universe readiness

Investigated on 2026-10-22. An unofficial template appears eligible in principle:
Universe's [naming rules](https://github.com/typst/packages/blob/main/docs/manifest.md#naming-rules)
explicitly distinguish community templates from official ones. Acceptance is
subject to maintainer review and would not constitute COLM approval. No Universe
submission has been made.

The current standalone repository needs these changes before submission:

- **Package metadata and name.** Add `typst.toml` with package metadata, a
  minimum compiler version, a `paper` category, and a `[template]` section.
  Select a unique prefix followed by `-colm`; `colm` is reserved for an official
  template, and package names must not include `typst`. The GitHub repository
  can keep its current name.
- **License.** Choose an accepted license, add `LICENSE`, and document which
  files have different terms. Universe recommends permissive terms such as
  MIT-0 for starter content so authors can distribute their resulting papers.
  See the [licensing requirements](https://github.com/typst/packages/blob/main/docs/licensing.md).
- **Fonts.** Universe currently forbids shipping font binaries, including
  inside the starter directory. Keep the bundled fonts in this GitHub
  distribution, but omit them from a Universe submission and document external
  installation or provide suitable fallbacks. Recheck layout if fonts change.
  See the [font restrictions](https://github.com/typst/packages/blob/main/docs/resources.md#fonts-are-not-supported-in-packages).
- **Starter and thumbnail.** Put starter content in a template directory, use
  a versioned `@preview/...` import, and add a thumbnail rendered from the
  initialized template. Test `typst init` and compilation in a fresh project.
  See the [template requirements](https://github.com/typst/packages/blob/main/docs/manifest.md#templates).

Once ready, submission is a pull request adding
`packages/preview/<name>/<version>/` to
[`typst/packages`](https://github.com/typst/packages/blob/main/docs/README.md).
Retain the unofficial-use warning in the package description, README, and
starter example. Publishing a version is a lasting commitment: registry
versions normally remain available, and fixes are released as new versions.
