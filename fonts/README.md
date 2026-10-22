# Bundled fonts

These are unmodified subsets of the upstream distributions. They make
compilation independent of locally installed fonts. Pass `--font-path fonts`
to the Typst CLI, or upload this directory with the paper in the web app.

| Files | Upstream distribution | License |
| --- | --- | --- |
| `texgyrepagella-{regular,bold,italic,bolditalic}.otf` | [TeX Gyre 2.501 OTF archive](https://www.gust.org.pl/projects/e-foundry/tex-gyre/whole/tg2_501otf.zip) | GUST Font License / LPPL 1.3c |
| `texgyrepagella-math.otf` | [TeX Gyre Pagella Math 1.632 archive](https://www.gust.org.pl/projects/e-foundry/tg-math/download/texgyrepagella-math-1632.zip) | GUST Font License / LPPL 1.3c |
| `Inconsolata-Regular.ttf` | [Google Fonts Inconsolata](https://github.com/google/fonts/tree/main/ofl/inconsolata) | SIL Open Font License 1.1 |
| `Inconsolatazi4-Regular.otf` | [CTAN Inconsolata 1.121](https://ctan.org/pkg/inconsolata) | SIL Open Font License 1.1 |

TeX Gyre fonts are by the GUST e-foundry; Pagella Math credits and maintenance
information are in `README-TeX-Gyre-Pagella-Math.txt`. Inconsolata is by Raph
Levien and contributors. Inconsolatazi4 is Michael Sharpe's TeX variant, used
for bibliography URLs to match COLM's LaTeX template. Its upstream notes are in
`README-Inconsolatazi4.txt`. The full upstream distributions are linked above.

License texts are included as `GUST-FONT-LICENSE.txt`, `LPPL-1.3c.txt`, and
`Inconsolata-OFL.txt` / `Inconsolatazi4-OFL.txt`. `SHA256SUMS` records the bundled font binaries.
