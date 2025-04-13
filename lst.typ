

// TODO: select DE/EN through document language

#let title-page(thesis-type, title, author, matriculation-number, supervisors, date) = [
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
]

#let lst(thesis-type: "Bachelor Thesis", title: none, author: none, matriculation-number: none, supervisors: none, date: none, city: "Saarbrücken", abstract: none, acknowledgments: none, content) = [
  #set page(
      paper: "a4", margin: ( bottom: 4cm, top: 4cm, left: 2.5cm, right: 2.5cm),
      numbering: none,
      number-align: center,
    )

  #set text(size: 12pt)
  #let leading-space = 0.7em
  #set par(leading: leading-space, spacing: 1em)

  // level 100 = headings in the frontmatter
  #show heading: it => {
    if it.level == 1 or it.level == 100 {
      pagebreak(to: "odd", weak: true)
      v(2cm)
      set text(font: ("Open Sans", "Libertinus Serif"), weight: "bold", size: 24pt)

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
        it.body
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
  #set figure(placement: top, numbering: n => {
    let h1 = counter(heading).get().first()
    numbering("1.1", h1, n)
  })

  // header with chapter numbers and titles
  #let fill-line(left-text, right-text) = [#left-text #h(1fr) #right-text]
  #set page(
      // Set page header
      header-ascent: 30%,
      header: context {
        // Get current page number
        let page-number = here().page()

        // If the current page is the start of a chapter, don't show a header
        let chapters = heading.where(level: 1)
        if query(chapters).any(it => it.location().page() == page-number) {
          return []
        }

        // Find the chapter of the section we are currently in
        let chapters-before = query(chapters.before(here()))
        if chapters-before.len() > 0 {
          let current-chapter = chapters-before.last()


          // If a new subsecion starts on this page, select that subsection.
          // Otherwise, select the last subsection
          let current-subsection = {
            let subsections = heading.where(level: 2)
            let subsections-after = query(subsections.after(here()))

            if subsections-after.len() > 0 {
              let next-subsection = subsections-after.first()

              if next-subsection.location().page() == page-number {
                (next-subsection)
              } else {
                let subsections-before = query(subsections.before(here()))

                if subsections-before.len() > 0 {
                  (subsections-before.last())
                } else {
                  // No subsections in this chapter
                  (none)
                }
              }
            }
          }

          let colored-slash = text(fill: gray, "--")
          let spacing = h(3pt)

          // Content to display subsection count and heading
          let subsection-text = if current-subsection != none {
            let subsection-numbering = current-subsection.numbering
            let location = current-subsection.location()
            let subsection-count = numbering(subsection-numbering,..counter(heading).at(location))

            [#subsection-count #spacing #colored-slash #spacing #current-subsection.body]
          } else {
            // No subsections in chapter, display nothing
            []
          }

          // Content to display chapter count and heading
          let chapter-text = {
            let chapter-title = current-chapter.body
            let chapter-number = str(counter(heading.where(level: 1)).get().first())

            [CHAPTER #chapter-number #spacing #colored-slash #spacing #chapter-title]
          }

          if current-chapter.numbering != none {
            // Show current chapter on odd pages, current subsection on even
            let (left-text, right-text) = if calc.odd(page-number) {
              (counter(page).display(), chapter-text)
            } else {
              (
                subsection-text,
                counter(page).display(),
              )
            }
            let (left-text, right-text) = if calc.odd(counter(page).get().first()) { ([], chapter-text) } else { (chapter-text, []) }
            //  (chapter-text, counter(page).display())
            text(
              weight: "thin",
              font: ("Open Sans"),
              size: 8pt,
              fill: gray,
              fill-line(upper(left-text), upper(right-text)),
              // [hmm]
            )
          }
        }
      },
    )




  // title page
  #title-page(thesis-type, title, author, matriculation-number, supervisors, date)
  

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
  #set par(justify: true)
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