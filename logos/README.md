# Logo assets

This directory keeps separate logo assets for screen and print output.

## Screen mode

Use `logos/screen/` for the default template mode:

- `logos/screen/lst-logo.svg`
- `logos/screen/uds-logo.svg`

These SVGs use the UdS style-guide screen color:

- RGB: `rgb(0, 72, 118)`
- Hex: `#004876`

This is the right choice for PDF previews, the Typst web app, browsers, slides,
and ordinary digital sharing.

## Print mode

Use `logos/print/` for `mode: "print"`:

- `logos/print/lst-logo.pdf`
- `logos/print/uds-logo.pdf`

These PDFs are vector assets using the UdS print color:

- CMYK: `100 / 40 / 0 / 50`
- PDF paint operator: `1 0.399902 0 0.5 k`

This avoids relying on viewer-specific RGB-to-CMYK conversion for print output.

## Raw sources

`logos/raw/` contains source and intermediate files used to derive the packaged
assets. The Typst template does not import files from `logos/raw/` directly.

The root-level `lst-logo.svg`, `uds-logo.svg`, and `uds-logo.pdf` are retained as
working/source derivatives. The packaged mode-specific assets are the files in
`logos/screen/` and `logos/print/`.

## Template selection

The template chooses assets through the `mode` argument:

```typst
#show: lst.with(
  mode: "screen", // default, RGB/SVG assets
  // mode: "print", // CMYK/PDF assets
)
```

Screen mode uses RGB colors and SVG logos. Print mode uses CMYK colors and PDF
logos.
