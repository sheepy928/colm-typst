// Layout calibration excerpt, adapted from the official COLM 2026 template.
// Yoav Artzi, COLM template contributors. CC BY 4.0.
// https://www.overleaf.com/latex/templates/colm-2026-template/wbwzrwczsqvg
// https://creativecommons.org/licenses/by/4.0/
// Converted to Typst; LaTeX logos are plain text. This is a test fixture.
#import "../colm.typ": colm
#show: colm.with(
  title: [Formatting Instructions for COLM 2026 \ Conference Submissions],
  abstract: [The abstract paragraph should be indented 1/2~inch (3~picas) on both
    left and right-hand margins. Use 10~point type, with a vertical spacing of
    11~points. The word _Abstract_ must be centered and in point size 12. Two line
    spaces precede the abstract. The abstract must be limited to one paragraph.],
)

= Submission of conference papers to COLM 2026

COLM requires electronic submissions, processed by
#link("https://openreview.net/")[`https://openreview.net/`]. See COLM's website
for more instructions. The format for the submissions is a variant of the
NeurIPS and ICLR formats. Please read carefully the instructions below, and
follow them faithfully.

== Style

Papers to be submitted to COLM 2026 must be prepared according to the instructions
presented here.

Authors are required to use the COLM LaTeX style files obtainable at the COLM
website. Please make sure you use the current files and not previous versions.
Tweaking the style files may be grounds for rejection.

=== Copy Options

If your paper is ultimately accepted, the option `final` should be set for the
`\usepackage[submission]{colm2026_conference}` command for the camera ready version.
The `submission` options is the default, and is to be used for all submissions during
the review process. It also turns on the line numbers. If you wish to submit a
preprint, the option `preprint` should be used.

== Retrieval of style files

The style files for COLM and other conference information are available online at:

#block(width: 100%, above: 12.934pt, below: 12.934pt)[
  #align(center)[#link("http://www.colmweb.org/")[`http://www.colmweb.org/`]]
]

The file `colm2026_conference.pdf` contains these instructions and illustrates the
various formatting requirements your COLM paper must satisfy. Submissions must be
made using LaTeX and the style files `colm2026_conference.sty` and
`colm2026_conference.bst` (to be used with LaTeX2e). The file `colm2026_conference.tex`
may be used as a “shell” for writing your paper. All you have to do is replace the
author, title, abstract, and text of the paper with your own.

The formatting instructions contained in these style files are summarized in
sections 2, 3, and 4 below.
