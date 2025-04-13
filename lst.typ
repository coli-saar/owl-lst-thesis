

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

#let lst(thesis-type: "Bachelor Thesis", 
          title: none, 
          author: none, 
          matriculation-number: none, 
          supervisors: none, 
          date: none, 
          city: "Saarbrücken", 
          abstract: none, 
          acknowledgments: none, 
          content) = [
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
      state("content.switch").update(false)
      pagebreak(weak: true, to: "odd")
      state("content.switch").update(true)

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

  // styling figures
  #set figure(placement: top, numbering: n => {
    let h1 = counter(heading).get().first()
    numbering("1.1", h1, n)
  })

  // styling links
  #let darkblue = rgb("000099")
  #show link: set text(fill: darkblue)
  #show cite: set text(fill: darkblue)
  #show ref: set text(fill: darkblue)

  // show page number only if page is not blank
  // This uses some state magic from here: https://github.com/typst/typst/discussions/3122
  #let page-footer = context {
    let has-content = state("content.pages", (0,)).get().contains(here().page())

    if has-content {
      align(center, counter(page).display())
    } else {
      [  ] // empty page
    }
  }

  // get content of the form "Chapter 3 -- Experiments"
  #let header-for-chapter() = context {
    let page-number = here().page()
    let chapters = heading.where(level: 1)
    if query(chapters).any(it => it.location().page() == page-number) {
      return []
    }

    // Find the chapter of the section we are currently in
    let chapters-before = query(chapters.before(here()))
    if chapters-before.len() > 0 {
      let current-chapter = chapters-before.last()
      
      // no header in un-numbered chapters
      if current-chapter.numbering == none {
        return []
      }

      let chapter-title = current-chapter.body
      let chapter-number = str(counter(heading.where(level: 1)).get().first())

      [Chapter #chapter-number  -- #chapter-title]
    }
  }

  // set page header (and do more magic for the blank pages)
  #let page-header = context {
    let page-here = here().page()
    // "start of chapter" is level 1 (real chapter) or 100 (section of the frontmatter)
    let is-start-chapter = query(heading.where(level: 1) .or(heading.where(level: 100))   ).any(it => it.location().page() == page-here)
    
    if not state("content.switch", false).get() and not is-start-chapter {
      [  ] // empty page
      return
    }

    // print header on pages that are not chapter starts
    if not is-start-chapter {
      align(if calc.odd(page-here) { right } else { left },
        text(weight: "thin", font: ("Open Sans"), size: 10pt, fill: gray)[
          #upper(header-for-chapter())
        ])
    }

    // update the list of pages on which the footer displays page numbers
    state("content.pages").update(it => return it + (page-here,))
  }

  #set page(footer: page-footer, header: page-header)


  /////////////////////////////////////////////////////////////////////////////

  // title page
  #title-page(thesis-type, title, author, matriculation-number, supervisors, date)
  
  // declaration page
  #set page(numbering: "i")
  #counter(page).update(0)
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
  #show outline.entry.where(level: 1): it => {
    v(12pt, weak: true)
    it
  }

  #outline(depth: 2) // show sections, but not subsections

  // main matter
  #set page(numbering: "1")
  #counter(page).update(0)
  #set heading(numbering: "1.1")

  #content
]