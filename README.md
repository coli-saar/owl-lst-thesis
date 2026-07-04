# Typst style for LST theses

This package provides a thesis style for the Department of Language Science and Technology
at Saarland University. It sets up the title page, declaration, abstract, acknowledgments,
table of contents, chapter styling, headers, page numbers, figure captions, and bibliography
formatting for an LST thesis.

Students should be able to start from `template/main.typ`, replace the sample metadata and
text, add bibliography entries to `custom.bib`, and compile.


## Quick start in the Typst web app

1. Open the Typst web app.
2. Create a new project from the `saar-lst-thesis` template if it is available in the template
   picker. Otherwise, create an empty project and copy the contents of `template/main.typ`
   and `template/custom.bib` into it.
3. Make sure the first lines import the LST template and Pergamon:

```typst
#import "@preview/saar-lst-thesis:0.1.0": *
#import "@preview/pergamon:0.8.0": *
```

4. Edit the metadata in the `#show` block.
5. Write the thesis below the `#show` block.
6. Add BibTeX entries to `custom.bib`.
7. Export the PDF from the web app.

The web app can fetch the `@preview` packages automatically. You do not need to upload
`lst.typ` or the logos when you use the published package import shown above.


## Quick start offline

Install Typst locally, download or clone this repository, and compile the sample thesis:

```sh
typst compile main.typ
```

For an offline thesis project, keep these files together:

- `main.typ`
- `custom.bib`
- `lst.typ`
- `logos/uds-logo.svg`
- `logos/lst-logo.pdf`

Use local imports at the top of `main.typ`:

```typst
#import "lst.typ": *
#import "@preview/pergamon:0.8.0": *
```

Then compile with:

```sh
typst compile main.typ my-thesis.pdf
```

Typst may still need network access once to download Pergamon. After Typst has cached the
package, compiling works offline from the local files.


## Minimal thesis file

This is the smallest useful shape of a thesis file:

```typst
#import "@preview/saar-lst-thesis:0.1.0": *
#import "@preview/pergamon:0.8.0": *

#set text(lang: "en")

#show: doc => lst(
  title: [My Thesis Title],
  author: [Jane Student],
  matriculation-number: [1234567],
  supervisors: (
    ([Supervisors], [Prof. Dr. First Supervisor], [Prof. Dr. Second Supervisor]),
    ([Additional advisor], [Dr. Helpful Advisor]),
  ),
  date: [31.12.2026],

  abstract: [
    Write a short summary of the thesis here.
  ],

  acknowledgments: [
    Optional acknowledgments go here.
  ],

  doc
)

#add-bib-resource(read("custom.bib"))

= Introduction

Start writing here. Cite papers with Pergamon like this #cite("bender-koller-2020-climbing").

#print-lst-bibliography()
```

If you work from this repository instead of the published package, replace the first import with
`#import "lst.typ": *`.


## Template arguments

The main function is `lst`. Use it in a `#show` rule around your document content.

- `title`: Thesis title shown on the title page.
- `author`: Your name.
- `matriculation-number`: Your matriculation number.
- `supervisors`: A tuple of supervisor groups. Each group starts with a role label, followed by
  one or more names.
- `date`: Submission date printed on the title page and declaration.
- `thesis-type`: Optional. Defaults to `Bachelor Thesis` in English and `Bachelorarbeit` in
  German.
- `city`: Optional. Defaults to `Saarbrücken` and is printed above the signature line in the
  declaration.
- `abstract`: Optional. If present, the template creates an abstract page.
- `acknowledgments`: Optional. If present, the template creates an acknowledgments page.

The template automatically creates:

- title page with LST and Saarland University logos;
- declaration page;
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
  ([Betreuung], [Prof. Dr. First Supervisor]),
  ([Weitere Betreuung], [Dr. Helpful Advisor]),
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

For tables, pass `kind: table` so the numbering and caption style are treated as a table:

```typst
#figure(kind: table, caption: [Example table.])[
  #table(
    columns: 2,
    [A], [B],
  )
] <tab:example>
```


## Citations and bibliography with Pergamon

This template uses Pergamon for author-year citations and bibliography formatting. Keep these
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

Cite a source by using its BibTeX key:

```typst
This distinction matters for language understanding #cite("bender-koller-2020-climbing").
```

Finally, print the bibliography at the end of the document:

```typst
#print-lst-bibliography()
```

`print-lst-bibliography` is provided by this template. It creates the LST-styled bibliography
heading and then asks Pergamon to print the bibliography.


## Fonts

The template uses Open Sans for headings, captions, headers, and title-page elements. Install
[Open Sans](https://fonts.google.com/specimen/Open+Sans) locally when compiling offline.

In the Typst web app, Open Sans is normally available without extra setup. If headings do not
look right in a local build, install Open Sans and compile again.


## Common changes

To write a master's thesis or another thesis type, set `thesis-type`:

```typst
#show: doc => lst(
  thesis-type: [Master Thesis],
  title: [My Thesis Title],
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


## Files in this repository

- `lst.typ`: The template implementation.
- `template/main.typ`: The file students should usually start from.
- `template/custom.bib`: Example bibliography file.
- `main.typ`: A longer sample document for testing the template.
- `custom.bib`: Bibliography used by the sample document.
- `logos/`: LST and Saarland University logos used on the title page.
- `typst.toml`: Package metadata for publishing the template.


## Licenses

The Typst source files are released under MIT-0.

The [Open Sans](https://fonts.google.com/specimen/Open+Sans) font is Copyright 2020 by The
Open Sans Project Authors and distributed under the
[SIL Open Font License 11](https://fonts.google.com/specimen/Open+Sans/license).

The Saarland University and LST logos in `logos/` are trademarks of their respective owners
and are not covered by the package license.
