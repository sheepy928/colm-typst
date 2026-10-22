// Unofficial; not affiliated with or endorsed by COLM.
// Do not use for conference submissions or camera-ready papers.
// Use the official LaTeX template: https://github.com/COLM-org/Template
#import "colm.typ": colm, colm-appendix, colm-acknowledgments

// Override with: typst compile --input mode=final ...
#let mode = sys.inputs.at("mode", default: "submission")
#show: colm.with(
  title: [An unofficial COLM-style paper in Typst],
  mode: mode,
  year: 2026,
  authors: (
    (name: "Alex Researcher",
     affiliation: [Department of Computer Science \ Example University],
     email: "alex@example.edu",
     note: [Corresponding author.]),
    (name: "Sam Scientist",
     affiliation: [Language Research Laboratory \ Example Institute],
     email: "sam@example.org"),
  ),
  keywords: ("language models", "conference template"),
  abstract: [
    This example demonstrates an unofficial Typst port of the COLM format,
    including citations, equations, figures, tables, and an appendix.
    It is not endorsed by COLM and should not be used for conference submissions
    or camera-ready papers; use the official LaTeX template for the conference.
    Submission mode anonymizes authors and enables line numbers. Preprint
    and final modes display the authors. Replace this paragraph with a summary
    of your research problem, approach, findings, and implications.
  ],
)

= Introduction <sec-introduction>

Introduce the problem, explain why it matters, and state the contributions.
All results in this example are illustrative placeholders, not experimental findings.

The transformer architecture is a common starting point for language modeling
@vaswani2017. For a narrative citation, write
#cite(<vaswani2017>, form: "prose"). Related work can include multiple references
@shannon1948 @vaswani2017. Citations link to an alphabetically ordered bibliography.

== Contributions

State contributions precisely and connect each one to evidence:

- Describe the method and the assumptions it requires.
- Explain the evaluation protocol and how comparisons are controlled.
- Summarize the findings and the limits of their interpretation.

== Paper organization

@sec-method introduces the method, @sec-results presents results, and
@sec-limitations discusses limitations. Additional details appear in @app-details.

= Method <sec-method>

== Model objective

Define symbols before using them. Given a token sequence $x_(1:T)$ and model
parameters $theta$, an illustrative language modeling objective is

$ cal(L)(theta) = - sum_(t=1)^T log p_theta(x_t | x_(<t)). $ <eq-loss>

@eq-loss and inline notation such as $x in RR^d$ use the Pagella math font.
Describe the algorithm, data, and compute budget sufficiently for another
researcher to reproduce the work.

=== Implementation details

Third-level headings use bold italic text. Use `monospace` for implementation
details and code blocks for configuration excerpts:

```yaml
seed: 42
batch_size: 32
learning_rate: 0.001
```

Footnotes provide short supporting details without interrupting the main
argument.#footnote[This is a sample footnote. Footnotes use 9 pt text and a
two-inch separator at the bottom of their page.]

= Results <sec-results>

Report datasets, baselines, uncertainty, and evaluation conditions.
@fig-pipeline illustrates a vector diagram made directly in Typst.
@tab-results demonstrates a table with horizontal rules and a caption below
the table, as specified by COLM.

#figure(
  placement: top,
  caption: [An example evaluation pipeline. Replace the boxes with a diagram
    that explains the proposed method.],
  alt: "A left-to-right pipeline from input tokens through a language model to evaluation.",
)[
  #set text(size: 9pt)
  #grid(
    columns: (1fr, auto, 1fr, auto, 1fr),
    align: center + horizon,
    gutter: 8pt,
    rect(width: 100%, inset: 10pt, stroke: 0.7pt)[Input tokens],
    [$arrow.r$],
    rect(width: 100%, inset: 10pt, stroke: 0.7pt)[Language model],
    [$arrow.r$],
    rect(width: 100%, inset: 10pt, stroke: 0.7pt)[Evaluation],
  )
] <fig-pipeline>

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, right, right),
    table.hline(stroke: 0.8pt),
    table.header([*Method*], [*Score*], [*Runs*]),
    table.hline(stroke: 0.5pt),
    [Baseline], [70.1], [3],
    [Proposed method], [72.4], [3],
    table.hline(stroke: 0.8pt),
  ),
  placement: top,
  caption: [Illustrative values only. Replace with measured results and
    appropriate uncertainty estimates.],
) <tab-results>

== Analysis

Discuss which observations support the explanation and where the method fails.
Include ablations that test each design choice, and distinguish observations
from conclusions requiring further evidence.

= Limitations <sec-limitations>

Describe limitations in the data, experimental design, compute budget, and
generalization of the conclusions. This template does not enforce the
conference page limit; inspect the compiled document before submission.

= Conclusion

Restate the supported findings and identify specific questions for future work.
Replace the example bibliography entries with the sources actually cited in
your paper.

#heading(numbering: none)[Ethics statement]

Discuss relevant ethical considerations, data governance, and potential impacts.
This optional section should be tailored to the work.

#colm-acknowledgments(mode: mode)[
  Replace this paragraph with acknowledgments and funding information.
]

#bibliography("references.bib")

#show: colm-appendix

= Additional details <app-details>

Appendix headings use letters while figure, table, and equation counters
continue from the main paper. The appendix starts on a new page.

== Reproducibility

Include full hyperparameters, dataset details, hardware information, and
evaluation procedures. Add further appendix sections as needed.

= Additional analysis

Include supplementary results that support the main text. Keep essential
evidence and claims in the main paper.
