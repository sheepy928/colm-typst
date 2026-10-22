#import "../colm.typ": colm
#show: colm.with(title: [COLM reference-format validation], mode: "preprint")

One author: @book.

Two authors: @article.

Three authors: @conference.

Narrative: #cite(<article>, form: "prose").

Citation order: @Vaswani2017 @article.

No date: @web.

Same label: @same-a @same-b.

Locator: #cite(<article>, supplement: [23]).

#pagebreak()
#bibliography("bibliography.bib", full: true)
