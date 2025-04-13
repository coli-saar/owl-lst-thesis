

// TODO: select DE/EN through document language

#let lst(thesis-type: "Bachelor Thesis", title: none, author: none, matriculation-number: none, supervisors: none, date: none, city: "Saarbrücken", abstract: none, acknowledgments: none, content) = [
  #set page(
      paper: "a4", margin: ( bottom: 5cm, top: 4cm),
      numbering: none,
      number-align: center,
    )

  #show heading.where(level: 1): it => {
    v(4em)
    set text(font: ("Open Sans", "Noto Sans", "Helvetica", "Libertinus Serif"), weight: "bold", size: 24pt)
    it
    v(1em, weak: true)
  }

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
        _Author_:\ #author\
        Matriculation number: #matriculation-number
      ]
    ],
    h(1fr),
    box()[
      #align(right)[
        _Supervisors_:\
        #supervisors.join(linebreak())
      ]
    ]
  )

  #v(1fr)
  #align(center)[Date of Submission\ #date]
  #pagebreak(to: "odd")

  // declaration page
  = Declaration

  I hereby confirm that the thesis presented here is my own work, with all assistance
  acknowledged. I assure that the electronic version is identical in content to the printed
  version of the thesis.

  #city, #date

  #v(5em)
  #line(length: 50%)
  #v(-0.5em)
  (#author)
  #pagebreak(to: "odd")

  // abstract
  #if abstract != none [
    = Abstract

    #abstract
    #pagebreak(to: "odd")
  ]

  // acknowledgments
  #if acknowledgments != none [
    = Acknowledgments

    #acknowledgments
    #pagebreak(to: "odd")
  ]


  #content
]