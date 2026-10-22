"""Check rendered baselines and line breaks against the LaTeX PDF, using PyMuPDF."""

import argparse
import json
from pathlib import Path
import unicodedata

import pymupdf


# PDF points (1/72 inch), measured from the COLM 2026 Overleaf PDF, page 1:
# https://www.overleaf.com/latex/templates/colm-2026-template/wbwzrwczsqvg.pdf
# Baselines, not glyph bounding boxes: font ascender metrics differ by renderer.
ANCHORS = (
    ("Under review as a conference paper", 35.369),
    ("Formatting Instructions for COLM", 92.169),
    ("Conference Submissions", 108.110),
    ("Anonymous authors", 139.252),
    ("Paper under double-blind review", 150.211),
    ("Abstract", 191.457),
    ("The abstract paragraph", 218.676),
    ("spaces precede the abstract", 251.553),
    ("Submission of conference papers", 293.402),
    ("COLM requires electronic submissions", 320.128),
    ("Style", 382.987),
    ("Papers to be submitted", 405.514),
    ("Authors are required", 433.411),
    ("Copy Options", 483.909),
    ("If your paper is ultimately accepted", 505.030),
    ("Retrieval of style files", 578.848),
    ("The style files for COLM", 601.375),
    ("http://www.colmweb.org/", 624.273),
    ("The file colm2026_conference.pdf", 647.172),
    ("The formatting instructions contained", 718.903),
    ("and 4 below.", 729.862),
)


def canonical(text):
    # PDF extraction splits words into spans and can omit space glyphs. The
    # reference also draws underscores as rules and uses a composed TeX logo.
    # Compare line membership without treating those encodings as new words.
    text = unicodedata.normalize("NFKC", text).replace("LATEX", "LaTeX")
    return "".join(text.replace("_", "").split())


def check(path):
    doc = pymupdf.open(path)
    assert len(doc) == 1, f"Calibration excerpt spilled onto {len(doc)} pages"
    page = doc[0]
    assert tuple(page.rect) == (0, 0, 612, 792), "Expected US Letter"
    lines = [
        ("".join(s["text"] for s in line["spans"]), line["spans"])
        for block in page.get_text("dict")["blocks"]
        for line in block.get("lines", [])
    ]
    errors = []
    for needle, expected in ANCHORS:
        matches = [spans for text, spans in lines if needle in text]
        assert matches, f"Missing reference text: {needle!r}"
        actual = matches[0][0]["origin"][1]
        error = abs(actual - expected)
        assert error < 0.1, f"{needle!r}: {actual:.3f} pt, expected {expected:.3f} pt"
        errors.append(error)

    # The rule and footer also moved in the first implementation.
    rule = next(d for d in page.get_drawings() if d["rect"].width > 390)
    assert abs(rule["rect"].x0 - 108) < 0.01
    assert abs(rule["rect"].width - 396) < 0.01
    assert abs(rule["rect"].y0 - 38.956) < 0.01
    assert abs(rule["rect"].height - 1.494) < 0.01
    footer = next(spans[0] for text, spans in lines
                  if text == "1" and spans[0]["origin"][1] > 750)
    assert abs(footer["origin"][1] - 759.750) < 0.01

    numbers = [spans[0] for text, spans in lines
               if text.isdigit() and spans[0]["origin"][0] < 100]
    assert [int(s["text"]) for s in numbers] == list(range(1, 33))
    assert all(abs(s["size"] - 5.9776) < 0.001 for s in numbers)

    expected_lines = json.loads(
        Path(__file__).with_name("reference-lines.json").read_text()
    )["lines"]
    spans = [span for _, row in lines for span in row]
    for number in numbers:
        n = number["text"]
        y = number["origin"][1]
        # Include the raised/lowered parts of the LaTeX logo, but not text on
        # adjacent baselines (11 TeX pt apart) or numbers in the left margin.
        row = sorted(
            (s for s in spans if s["origin"][0] > 100
             and abs(s["origin"][1] - y) < 3),
            key=lambda s: s["origin"][0],
        )
        actual = "".join(s["text"] for s in row)
        expected = expected_lines[n]
        assert canonical(actual) == canonical(expected), (
            f"Line {n} wraps differently:\nLaTeX: {expected}\nTypst: {actual}"
        )
    print(f"PASS: {len(ANCHORS)} LaTeX baseline anchors; max error {max(errors):.4f} pt")
    print("PASS: page dimensions, header rule, footer, and 32 continuous 6-TeX-pt line numbers")
    print("PASS: all 32 numbered lines contain the same text as the LaTeX reference")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("pdf", type=Path, nargs="?", default=Path("build/reference.pdf"))
    check(parser.parse_args().pdf)
