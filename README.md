# Typst style for LST theses

This is the official Typst thesis style
for the [Department of Language Science and Technology](https://www.lst.uni-saarland.de/)
at [Saarland University](https://www.uni-saarland.de/). 
You can use this for your Bachelor's or Master's Thesis or any other document you like.

The template sets up the title page, declaration, abstract, acknowledgments,
table of contents, chapter styling, headers, page numbers, figure captions, and bibliography
formatting for an LST thesis.
It is intended for double-sided printing and binding; the inner margin is wider than the outer one.


## Quick start in the Typst web app

1. Open the Typst web app.
2. Create a new project from the `saar-lst-thesis` template.
3. Edit the metadata in the `#show` block.
4. Add BibTeX entries and import your BibTeX file with `add-bib-resource`.

You can write the thesis below the `#show: lst` block and export the PDF from the web app.


## Minimal thesis file

This is the smallest useful shape of a thesis file:

```typst
#import "@preview/saar-lst-thesis:0.1.0": *
#import "@preview/pergamon:0.8.0": *

#set text(lang: "en")

#show: lst.with(
  title: "My Thesis Title",
  author: "Jane Student",
  matriculation-number: "1234567",
  supervisors: (
    ("Supervisors", "Prof. Dr. First Supervisor", "Prof. Dr. Second Supervisor"),
    ("Additional advisor", "Dr. Helpful Advisor"),
  ),
  date: "31.12.2026",

  abstract: [
    Write a short summary of the thesis here.
  ],

  acknowledgments: [
    Optional acknowledgments go here.
  ])

#add-bib-resource(read("custom.bib"))

= Introduction

Start writing here. Cite papers with Pergamon like this #cite("bender-koller-2020-climbing").

#print-lst-bibliography()
```


## Template arguments

The main function is `lst`. Use it in a `#show` rule around your document content.

- `title`: Thesis title shown on the title page and stored in the PDF metadata. Must be a string.
- `author`: Your name, stored in the PDF metadata. Must be a string.
- `matriculation-number`: Your matriculation number. Must be a string.
- `supervisors`: A tuple of supervisor groups. Each group starts with a role label, followed by
  one or more names. Use strings for all labels and names.
- `date`: Submission date printed on the title page and declaration. Must be a string.
- `thesis-type`: Optional string. Defaults to `Bachelor Thesis` in English and `Bachelorarbeit`
  in German.
- `city`: Optional string. Defaults to `Saarbrücken` and is printed above the signature line in the
  declaration.
- `abstract`: Optional. If present, the template creates an abstract page.
- `acknowledgments`: Optional. If present, the template creates an acknowledgments page.

The template automatically creates:

- title page with LST and Saarland University logos;
- declaration page;
- PDF metadata with the thesis title, author, and template preparation string;
- abstract and acknowledgments pages when provided;
- table of contents to section depth;
- main-matter page numbering;
- odd-page chapter starts with blank pages where needed;
- running headers with chapter and section information;
- chapter-based numbering for figures, tables, raw figures, and equations;
- LST-styled captions, links, references, and bibliography heading.


## Language

The template localizes its built-in labels from Typst's document language. It defaults to
English. Use German with:

```typst
#set text(lang: "de")
```

This translates template chrome such as chapter labels, front-matter headings, title-page
fields, and the declaration. User-provided thesis text and supervisor role labels are not
translated automatically, so write those labels yourself:

```typst
supervisors: (
  ("Gutachter", "Prof. Dr. First Supervisor", "Prof. Dr. External Reviewer"),
  ("Betreuerin", "Dr. Helpful Advisor"),
)
```


## Writing structure

Use normal Typst headings:

```typst
= Chapter
== Section
=== Subsection
==== Paragraph-style heading
```

The table of contents includes chapters and sections. Subsections and lower heading levels are
not shown in the table of contents.

Use labels for cross-references:

```typst
= Introduction <sec:introduction>

As discussed in @sec:introduction, ...
```

Use figures and tables with labels:

```typst
#figure(caption: [Example figure.])[
  #image("figure.pdf", width: 80%)
] <fig:example>

See @fig:example.
```



## Citations and bibliography with Pergamon

This template uses [Pergamon](https://typst.app/universe/package/pergamon) for author-year citations and bibliography formatting. Keep these
three pieces in your thesis file:

```typst
#import "@preview/pergamon:0.8.0": *

#add-bib-resource(read("custom.bib"))

#print-lst-bibliography()
```

Add references to `custom.bib` in normal BibTeX format:

```bibtex
@inproceedings{bender-koller-2020-climbing,
  title = {Climbing towards NLU},
  author = {Bender, Emily M. and Koller, Alexander},
  year = {2020},
  booktitle = {Proceedings of ACL},
}
```

Cite a source in parentheses with `#cite` and as a noun phrase as `#citet`.
Pass the BibTeX key as a string (not as a label like in the default Typst `cite` command):

```typst
#citet("bender-koller-2020-climbing") argued that meaning cannot be learned from form alone.
```

Finally, print the bibliography at the end of the document:

```typst
#print-lst-bibliography()
```

`print-lst-bibliography` is provided by this template. It creates the LST-styled bibliography
heading and then asks Pergamon to print the bibliography.


## Fonts

The template uses Libertinus Serif for the main text and Open Sans for headings, captions, headers, and title-page elements. Install
[Open Sans](https://fonts.google.com/specimen/Open+Sans) locally when compiling offline.

In the Typst web app, Libertinus Serif and Open Sans should be available without extra setup. 


## Common changes

To write a master's thesis or another thesis type, set `thesis-type`:

```typst
#show: doc => lst(
  thesis-type: "Master Thesis",
  title: "My Thesis Title",
  ...
  doc
)
```

To omit acknowledgments, remove the `acknowledgments` argument. To omit the abstract, remove
the `abstract` argument.

To use German labels throughout the template, set the document language before the `#show`
rule:

```typst
#set text(lang: "de")
```


## Licenses

The Typst source files are released under MIT.

The [Open Sans](https://fonts.google.com/specimen/Open+Sans) font is Copyright 2020 by The
Open Sans Project Authors and distributed under the
[SIL Open Font License 11](https://fonts.google.com/specimen/Open+Sans/license).

The Saarland University and LST logos in `logos/` are trademarks of their respective owners
and are not covered by the package license.
