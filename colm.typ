// Unofficial Typst implementation calibrated against the COLM 2026 LaTeX PDF.
// Not endorsed by COLM. Do not use for conference submissions or camera-ready papers.
// Official LaTeX template: https://github.com/COLM-org/Template
// https://www.overleaf.com/latex/templates/colm-2026-template/wbwzrwczsqvg.pdf
// LaTeX points are 1/72.27 inch; Typst points are 1/72 inch.
#let tex-pt = 72pt / 72.27
// Only ordinary, breakable whitespace: an explicit `~` must stay nonbreaking.
#let sentence-end = regex("[a-z]+[.!?]([ \\t\\r\\n]+|$)")
#let sentence-scope = state("colm-sentence-scope", 0)
#let without-sentence-spacing(it) = {
  sentence-scope.update(depth => depth + 1)
  it
  sentence-scope.update(depth => depth - 1)
}

#let colm(
  title: [],
  authors: (),
  abstract: none,
  mode: "submission",
  year: 2026,
  author-columns: 2,
  keywords: (),
  sentence-spacing: true,
  body,
) = {
  assert(("submission", "preprint", "final").contains(mode),
    message: "mode must be submission, preprint, or final")
  assert(type(author-columns) == int and author-columns > 0,
    message: "author-columns must be a positive integer")
  let anonymous = mode == "submission"
  let blue = rgb("000080")
  let running-head = if anonymous {
    [Under review as a conference paper at COLM #year]
  } else if mode == "final" {
    [Published as a conference paper at COLM #year]
  } else {
    [Preprint. Under review.]
  }

  set document(
    title: title,
    author: if anonymous { () } else { authors.map(a => a.name) },
    keywords: keywords,
    date: none,
  )
  // A TeX-like strut gives a 10 pt first baseline and 11 pt subsequent ones.
  set text(font: "TeX Gyre Pagella", size: 10 * tex-pt, lang: "en",
    top-edge: 10 * tex-pt, bottom-edge: 0pt, costs: (runt: 200%))
  // Palatino's pplr8t.tfm: space .25em, stretch .15em, shrink .06em.
  // Typst's defaults use different glue and can squeeze an extra word in.
  set par(justify: true, leading: tex-pt, spacing: 7 * tex-pt,
    justification-limits: (spacing: (min: 76%, max: 160%)),
    first-line-indent: 0pt)
  show sentence-end: it => context {
    if sentence-scope.get() > 0 { return it }
    // TeX adds .06em after a sentence (.31 / .25 = 124%). Keep the final
    // word intact so the paragraph optimizer can penalize single-word tails.
    text(hyphenate: false, it.text.trim(at: end))
    if it.text.ends-with(regex("[ \\t\\r\\n]")) {
      text(spacing: if sentence-spacing { 124% } else { 100% })[ ]
    }
  }
  // article.cls + COLM's topmargin/headheight/headsep, measured in the PDF.
  let text-top = 0.625in + 37 * tex-pt
  set page(
    paper: "us-letter",
    margin: (x: 1.5in, top: text-top, bottom: 2in - text-top),
    header-ascent: text-top - 40.45pt,
    footer-descent: 20 * tex-pt,
    header: {
      set par.line(numbering: none)
      set par(justify: false, spacing: 0pt)
      block(width: 100%, below: 0pt)[
        #running-head
        #v(3.6 * tex-pt)
        #rect(width: 100%, height: 1.5 * tex-pt, stroke: none, fill: black)
      ]
    },
    footer: context {
      set par.line(numbering: none)
      align(center, counter(page).display("1"))
    },
  )
  set par.line(
    numbering: if anonymous { n => text(size: 6 * tex-pt, weight: "regular", style: "normal", str(n)) } else { none },
    number-margin: left,
    number-align: right,
    number-clearance: 10 * tex-pt,
    numbering-scope: "document",
  )

  set heading(numbering: "1.1", supplement: [Section])
  show heading: set text(weight: "bold")
  show heading: set par(justify: false)
  show heading.where(level: 1): set text(size: 12 * tex-pt)
  show heading.where(level: 2): set text(size: 10 * tex-pt)
  show heading.where(level: 3): set text(size: 10 * tex-pt, style: "italic")
  // Baseline gaps measured on the reference PDF. The LaTeX
  // output includes paragraph glue in addition to the section's own skips.
  show heading: it => context {
    let level = calc.min(it.level, 3) - 1
    let before = (21.65pt, 20.022pt, 18.620pt).at(level)
    let after = (16.763pt, 12.562pt, 11.157pt).at(level)
    let prefix = if it.numbering != none {
      [#counter(heading).display(it.numbering)#h(1em)]
    } else { [] }
    set par(hanging-indent: measure(prefix).width)
    block(above: before, below: after, sticky: true)[#prefix#it.body]
  }

  show math.equation: set text(font: "TeX Gyre Pagella Math")
  set math.equation(numbering: "(1)")
  show math.equation.where(block: true): set block(above: 7pt, below: 7pt)
  show raw: set text(font: "Inconsolata", size: 10 * tex-pt)
  show raw: without-sentence-spacing
  show link: set text(fill: blue)
  show ref: set text(fill: blue)
  show cite: set text(fill: blue)
  show cite: without-sentence-spacing
  // natbib uses a one-em hanging indent and eight TeX points between entries.
  show bibliography: it => {
    // Typst's CSL renderer fixes the hanging indent at 1.5em. Adjust its
    // entry blocks to natbib's 1em without rebuilding citation targets.
    show block: entry => {
      if type(entry.inset) == dictionary and entry.inset.at("left", default: 0pt) == 1.5em {
        let fields = entry.fields()
        let body = fields.remove("body")
        block(..(fields + (inset: (left: 1em),
          above: 0pt, below: 9 * tex-pt)))[#h(0.5em)#body]
      } else { entry }
    }
    show heading: title => block(above: 19.307pt, below: 8.005pt, sticky: true)[
      #set par(hanging-indent: 0pt)
      #text(size: 12 * tex-pt, weight: "bold", title.body)
    ]
    // LaTeX uses monospace for URL fields, but roman text for DOI fields.
    show link: link => {
      if link.body.func() == text and link.body.text.starts-with("10.") { link }
      else { text(font: "Inconsolatazi4", link) }
    }
    // Hayagriva's automatic BibLaTeX genres differ from plain BibTeX's.
    // The CSL tags only the genre with smallcaps so titles are unaffected.
    show smallcaps: genre => {
      show "Doctoral dissertation": [PhD thesis]
      show "technical report": [Technical Report]
      genre.body
    }
    // BibTeX's add.period$ preserves a title's existing terminal punctuation.
    show regex("[!?]\\."): it => text(it.text.slice(0, -1))
    without-sentence-spacing(it)
  }
  set cite(style: "colm.csl")
  set bibliography(style: "colm.csl", title: [References])

  set figure(gap: 11pt)
  set figure.caption(position: bottom, separator: [: ])
  show figure: set par.line(numbering: none)
  show figure: set block(above: 11pt, below: 11pt, breakable: false)
  show figure.caption: set par(justify: true)
  set table(stroke: none, inset: (x: 6pt, y: 4pt))
  show table: set text(size: 9 * tex-pt, top-edge: 9 * tex-pt)

  set footnote.entry(separator: line(length: 2in, stroke: 0.4pt),
    clearance: 9pt, gap: 6.65pt, indent: 1em)
  show footnote.entry: set text(size: 9 * tex-pt, top-edge: 9 * tex-pt)
  show footnote.entry: set par.line(numbering: none)
  set list(indent: 0pt, body-indent: 1.5em, spacing: 2pt)
  set enum(indent: 0pt, body-indent: 1.5em, spacing: 2pt)

  // Keep the title and author block together and outside the line count.
  block(breakable: false, below: 31.283pt)[
    #set par.line(numbering: none)
    #set par(justify: false)
    #block(below: 21.18pt)[
      #set text(size: 14.4 * tex-pt, weight: "bold", top-edge: 10.307pt)
      #set par(leading: 16 * tex-pt - 10.307pt)
      #title
    ]
    #if anonymous {
      pad(left: 6 * tex-pt)[*Anonymous authors* \ Paper under double-blind review]
    } else if authors.len() > 0 {
      pad(x: 6 * tex-pt, grid(
        columns: (1fr,) * calc.min(author-columns, authors.len()),
        column-gutter: 18pt,
        row-gutter: 12pt,
        ..authors.map(a => block(breakable: false)[
          #strong(a.name)
          #if a.at("note", default: none) != none { footnote(numbering: "*", a.note) }
          #if a.at("affiliation", default: none) != none { linebreak(); a.affiliation }
          #if a.at("email", default: none) != none {
            linebreak()
            text(font: "Inconsolata", size: 9 * tex-pt, a.email)
          }
        ]),
      ))
    }
  ]
  counter(footnote).update(0)

  if abstract != none {
    block(width: 100%, inset: (x: 36 * tex-pt), above: 0pt, below: 31.89pt)[
      #block(width: 100%, below: 17.256pt)[
        #set par.line(numbering: none)
        #align(center, text(size: 12 * tex-pt, weight: "bold", [Abstract]))
      ]
      #abstract
    ]
  }
  body
}

// Scoped show rule: reset only the heading counter; retain other counters.
// Use once at the end: #show: colm-appendix
#let colm-appendix(body) = {
  pagebreak(weak: true)
  counter(heading).update(0)
  set heading(numbering: "A.1", supplement: [Appendix])
  body
}

// Funding acknowledgments must not identify authors during anonymous review.
#let colm-acknowledgments(body, mode: "submission") = {
  assert(("submission", "preprint", "final").contains(mode),
    message: "mode must be submission, preprint, or final")
  if mode != "submission" {
    heading(numbering: none)[Acknowledgments]
    body
  }
}
