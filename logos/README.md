# Logo assets

The template uses the RGB logo assets in `logos/rgb/` for both `mode: "screen"`
and `mode: "print"`:

- `logos/rgb/lst-logo.svg`
- `logos/rgb/uds-logo.svg`

Both SVGs use the UdS style-guide screen color:

- RGB: `rgb(0, 72, 118)`
- Hex: `#004876`

Using one RGB color model for both the live Typst text and the embedded logo
assets avoids object-specific color handling in ordinary PDF viewers and office
printer drivers. The `print` mode still changes the page margins for binding,
but it does not switch to CMYK logo files.

## CMYK References

`logos/cmyk/` contains CMYK PDF versions of the logos:

- `logos/cmyk/lst-logo.pdf`
- `logos/cmyk/uds-logo.pdf`

These are retained as reference assets for possible professional-print workflows.
They are not used by the Typst template by default.

## Raw Sources

`logos/raw/` contains source and intermediate files used to derive the packaged
assets. The Typst template does not import files from `logos/raw/` directly.
