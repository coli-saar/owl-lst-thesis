

// TODO: select DE/EN through document language

#let lst(thesis-type: "Bachelor Thesis", title: none, author: none, matriculation-number: none, supervisors: none, date: none, city: "Saarbrücken", abstract: none, acknowledgments: none, content) = [
  #set page(
      paper: "a4", margin: ( bottom: 5cm, top: 4cm),
      numbering: none,
      number-align: center,
    )

  #set text(size: 12pt)
  #let leading-space = 0.5em
  #set par(leading: leading-space, spacing: 1em, justify: true)

  // level 100 = headings in the frontmatter
  // TODO: Why do level-100 headings have less whitespace above them than the others?
  #show heading: it => {
    if it.level == 1 or it.level == 100 {
      pagebreak(to: "odd", weak: true)
      v(4em)
      set text(font: ("Open Sans", "Helvetica", "Libertinus Serif"), weight: "bold", size: 24pt)

      if it.level == 1 and it.numbering != none {
        [Chapter #context(counter(heading).display())]
        v(0em)
        it.body

        // Reset figure numbering on every chapter start
        for kind in (image, table, raw) {
          counter(figure.where(kind: kind)).update(0)
          // Also reset equation numbering
          counter(math.equation).update(0)
        }
      } else {        
        it
      }
      v(2em, weak: true)
    } else if it.level == 2 {
      v(1em)
      text(size: 18pt, it)
      v(1.5em, weak: true)
    } else {
      v(0em)
      it
      v(1em, weak: true)
    }
  }

  // styling TOC
  #show outline.entry.where(level: 1): it => {
    v(12pt, weak: true)
    it
  }

  // styling figures
  #show figure.caption: it => {
    set align(left)
    block(inset: 1em)[#it]
  }

  #set figure(placement: top)





  // title page
  #align(center)[#image("uds-logo.svg", width: 4cm)]
  #align(center)[
    #text(size: 24pt)[#smallcaps[Saarland University]]
  ]
  #align(center)[
    #move(dy: -1em)[#text(size: 17pt, weight: 10)[#smallcaps[Department of Language Science and Technology]]]
  ]

  #v(2em)
  #line(length: 100%, stroke: 1.5pt)
  #align(center)[
    #text(size: 15pt)[#smallcaps()[#thesis-type]]
    #v(-1em)
    #set par(leading: 0.4em)
    #text(size: 30pt, weight: "medium")[#title]
  ]
  #v(-1.5em)
  #line(length: 100%, stroke: 1.5pt)

  #v(3em)
  #stack(dir: ltr,
    box()[
      #align(left)[
        _Author:_\ #author\
        Matriculation number: #matriculation-number
      ]
    ],
    h(1fr),
    box()[
      #align(right)[
        _Supervisors:_\
        #supervisors.join(linebreak())
      ]
    ]
  )

  #v(1fr)
  #align(center)[Date of Submission\ #date]

  #set page(numbering: "i")
  #counter(page).update(1)
  // TODO: suppress page numbers on blank pages, cf. https://github.com/typst/typst/discussions/3122

  // declaration page
  #heading(level: 100)[Declaration]

  I hereby confirm that the thesis presented here is my own work, with all assistance
  acknowledged. I assure that the electronic version is identical in content to the printed
  version of the thesis.

  #city, #date

  #v(5em)
  #line(length: 50%)
  #v(-0.5em)
  (#author)

  // abstract
  #if abstract != none [
    #heading(level: 100)[Abstract]

    #abstract
  ]

  // acknowledgments
  #if acknowledgments != none [
    #heading(level: 100)[Acknowledgments]

    #acknowledgments
  ]

  // table of contents
  #outline(depth: 99)

  // TODO: suppress page number 0
  #set page(numbering: "1")
  #counter(page).update(0)

  #set heading(numbering: "1.1")

  #content
]