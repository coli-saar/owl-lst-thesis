

// TODO: select DE/EN through document language

#let uds-blue = rgb(0, 72, 119)
#let text-gray = luma(95)

#let advisors(supervisors) = {
  for (j, sup) in supervisors.enumerate() {
    let role = sup.at(0)
    let names = sup.slice(1)

    strong(role)
    for (i, name) in names.enumerate() {
      linebreak()
      name
    }

    if j < supervisors.len() - 1 {
      linebreak()
      linebreak()
    }
  }
}

#let title-page(thesis-type, title, author, matriculation-number, supervisors, date) = {
  set text(font: "Open Sans")

  stack(dir: ltr,
    box(
      text(size: 12pt, fill: uds-blue)[
        *#thesis-type*\
        Department of Language Science and Technology\
        Saarland University
      ]
    ),
    h(1fr),

    stack(dir: ltr,
      image("logos/lst-logo.pdf", width: 1.45cm),
      h(0.5cm),
      move(dy: -0.08cm, image("logos/uds-logo.svg", width: 1.6cm))
    )
  )

  v(4.3cm)

  text(size: 18pt, author)
  v(0em)
  text(size: 24pt, weight: "bold", fill: uds-blue, title)

  v(1fr)


  advisors(supervisors)

  place(bottom + right)[
    *Matriculation Number*\
    #matriculation-number\
    \
    *Submission Date*\
    #date
  ]
}




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
      paper: "a4", margin: ( bottom: 3cm, top: 3cm, inside: 3.5cm, outside: 2.5cm), // left: 2.5cm, right: 2.5cm),
      numbering: none,
      number-align: center,
    )

  #set text(size: 12pt)
  #let leading-space = 0.7em
  #set par(leading: leading-space, spacing: 2 * leading-space)

  // level 100 = headings in the frontmatter
  #show heading: it => {
    if it.level == 1 or it.level == 100 {
      state("content.switch").update(false)
      pagebreak(weak: true, to: "odd")
      state("content.switch").update(true)

      v(2cm)
      set text(font: ("Open Sans", "Libertinus Serif"), weight: "bold", size: 24pt, fill: uds-blue)

      if it.level == 1 and it.numbering != none {
        text(font: "Open Sans", size: 11pt, fill: text-gray)[Chapter #context(counter(heading).display())]
        v(-0.6em)
        text(fill: uds-blue, it.body)

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
      text(font: "Open Sans", size: 18pt, weight: "bold", it)
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
  #show figure.caption: it => {
    set text(font: "Open Sans", size: 9.5pt)
    text(fill: uds-blue, weight: "semibold", it.supplement)
    h(0.35em)
    text(fill: uds-blue, weight: "semibold", it.counter.display())
    text(fill: text-gray)[:]
    h(0.35em)
    text(fill: text-gray, it.body)
  }

  // styling links
  #show link: set text(fill: uds-blue)
  #show cite: set text(fill: uds-blue)
  #show ref: set text(fill: uds-blue)

  // show page number only if page is not blank
  // This uses some state magic from here: https://github.com/typst/typst/discussions/3122
  #let page-footer = context {
    let has-content = state("content.pages", (0,)).get().contains(here().page())

    if has-content {
      let page-here = here().page()
      align(
        if calc.odd(page-here) { right } else { left },
        text(font: "Open Sans", size: 9.5pt, fill: uds-blue, weight: "semibold", counter(page).display())
      )
    } else {
      [  ] // empty page
    }
  }

  #let heading-number-at(it) = {
    let nums = counter(heading).at(it.location())
    numbering("1.1", ..nums)
  }

  // get content of the form "Chapter 3 / Experiments"
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

      text(fill: uds-blue, weight: "semibold")[Chapter #chapter-number]
      h(0.35em)
      text(fill: text-gray)[/]
      h(0.35em)
      text(fill: text-gray, chapter-title)
    }
  }

  // get content of the form "2.3 / Previous Work"
  #let header-for-section() = context {
    let page-number = here().page()
    let sections = heading.where(level: 2)
    if query(sections).any(it => it.location().page() == page-number) {
      return []
    }

    let sections-before = query(sections.before(here()))
    if sections-before.len() > 0 {
      let current-section = sections-before.last()
      let section-title = current-section.body
      text(fill: uds-blue, weight: "semibold")[#heading-number-at(current-section)]
      h(0.35em)
      text(fill: text-gray)[/]
      h(0.35em)
      text(fill: text-gray, section-title)
    } else {
      header-for-chapter()
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
      let header-content = if calc.odd(page-here) {
        header-for-section()
      } else {
        header-for-chapter()
      }

      align(if calc.odd(page-here) { right } else { left },
        text(font: "Open Sans", size: 9.5pt)[
          #header-content
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
  #v(-2em)
  I hereby confirm that the thesis presented here is my own work, with all assistance
  acknowledged. I assure that the electronic version is identical in content to the printed
  version of the thesis.
  #v(2em)

  #city, #date

  #v(5em)
  #line(length: 50%)
  #v(-0.5em)
  (#author)

  // abstract
  #set par(justify: true)
  #if abstract != none [
    #heading(level: 100)[Abstract]
    #v(-2em)
    #abstract
  ]

  // acknowledgments
  #if acknowledgments != none [
    #heading(level: 100)[Acknowledgments]
    #v(-2em)
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
