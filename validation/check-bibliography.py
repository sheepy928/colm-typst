"""Compare references with COLM BibTeX output and check PDF typography."""

import argparse
import json
from pathlib import Path
import unicodedata

import pymupdf


def canonical(text):
    return "".join(unicodedata.normalize("NFKC", text).replace("\u00ad", "").split())


def check(path):
    expected = json.loads(
        Path(__file__).with_name("bibliography-expected.json").read_text()
    )["entries"]
    doc = pymupdf.open(path)
    assert len(doc) == 2, f"Expected two fixture pages, got {len(doc)}"
    citations = canonical(doc[0].get_text())
    for citation in (
        "One author: (Alpha, 2020).",
        "Two authors: (Alpha & Beta, 2024).",
        "Three authors: (Alpha et al., 2025).",
        "Narrative: Alpha & Beta (2024).",
        "Citation order: (Vaswani et al., 2017; Alpha & Beta, 2024).",
        "No date: (Example Organization).",
        "Locator: (Alpha & Beta, 2024, 23).",
    ):
        assert canonical(citation) in citations, f"Missing citation: {citation}"

    page = doc[1]
    rows = [
        line["spans"]
        for block in page.get_text("dict")["blocks"]
        for line in block.get("lines", [])
        if 100 < line["spans"][0]["origin"][1] < 740
    ]
    actual = canonical("".join(s["text"] for row in rows for s in row))
    reference = canonical("".join(entry["text"] for entry in expected))
    assert actual == reference, (
        "Bibliography differs from official COLM BibTeX output.\n"
        f"Expected: {reference}\nActual: {actual}"
    )

    tex_pt = 72 / 72.27
    assert abs(rows[0][0]["origin"][1] - 109.792) < 0.01
    starts = []
    for i, row in enumerate(rows):
        x, y = row[0]["origin"]
        if abs(x - 108) < 0.01:
            starts.append(i)
            if i:
                # natbib's 11pt baseline plus 8pt bibliography item gap.
                assert abs(y - rows[i - 1][0]["origin"][1] - 19 * tex_pt) < 0.01
        else:
            assert abs(x - 108 - 10 * tex_pt) < 0.01, "Hanging indent must be one em"
            assert abs(y - rows[i - 1][0]["origin"][1] - 11 * tex_pt) < 0.01
    assert len(starts) == len(expected)
    # Extracted span bounds can include trailing spaces outside the measure.
    # Typst also permits optical punctuation overhang, so check visible glyphs.
    chars = [char for block in page.get_text("rawdict")["blocks"]
             for line in block.get("lines", []) for span in line["spans"]
             for char in span["chars"]
             if 100 < char["origin"][1] < 740 and not char["c"].isspace()]
    assert all(char["bbox"][2] <= 504.1
               or (char["c"] in ".,;:–—-" and char["bbox"][2] <= 507)
               for char in chars), "Reference overflows"

    spans = [s for row in rows for s in row]
    urls = [s for s in spans if "https://" in s["text"]]
    assert urls and all("Inconsolatazi4" in s["font"] for s in urls)
    dois = [s for s in spans if "10.1234/example" in s["text"]]
    assert dois and all("Pagella" in s["font"] for s in dois)
    venues = [s for s in spans if "Journal of Examples" in s["text"]]
    assert venues and all("Italic" in s["font"] for s in venues)
    assert all(abs(s["size"] - 10 * tex_pt) < 0.01 for s in spans)
    assert any(link["uri"] == "https://example.org/article"
               for link in page.get_links() if "uri" in link)
    assert any(link.get("page") == 1 for link in doc[0].get_links()), "Citation links lost"
    print("PASS: 10 references match official COLM BibTeX output, including order and year suffixes")
    print("PASS: author-year citations, punctuation, narrative form, and citation order")
    print("PASS: hanging indent, entry/line spacing, fonts, italics, and working links")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("pdf", type=Path, nargs="?", default=Path("build/bibliography.pdf"))
    check(parser.parse_args().pdf)
