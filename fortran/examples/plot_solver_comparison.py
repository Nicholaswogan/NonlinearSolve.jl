#!/usr/bin/env python3
"""
Generate a plot comparing trust_region_solve vs MINPACK hybrj1 on the Burkardt test set.

The script runs the built executable ../../build/run_test_nonlin, parses its table output,
and produces a PNG with side-by-side bar charts for average runtime and final residual norm.
"""

import re
import subprocess
import sys
from pathlib import Path

import matplotlib.pyplot as plt


def parse_table(text: str):
    rows = []
    for line in text.splitlines():
        if not line.strip():
            continue
        if line.lstrip().startswith("problem") or line.lstrip().startswith("-"):
            continue
        # Strip column separators then split.
        parts = line.replace("|", " ").split()
        if len(parts) < 13:
            continue

        def parse_float(val: str) -> float:
            v = val.replace("D", "E")
            if re.match(r"^[+-]?\d*\.\d*(?:[eE][+-]?\d+)?$", v):
                return float(v)
            m = re.match(r"^([+-]?\d*\.\d*)([+-]\d+)$", v)
            if m:
                return float(f"{m.group(1)}E{m.group(2)}")
            return float(v)

        try:
            rows.append(
                {
                    "problem": int(parts[0]),
                    "n": int(parts[1]),
                    "tr_ret": int(parts[2]),
                    "tr_nf": int(parts[3]),
                    "tr_njac": int(parts[4]),
                    "tr_nsolve": int(parts[5]),
                    "tr_time": parse_float(parts[6]),
                    "tr_fnorm": parse_float(parts[7]),
                    "mp_ret": int(parts[8]),
                    "mp_nf": int(parts[9]),
                    "mp_njac": int(parts[10]),
                    "mp_time": parse_float(parts[11]),
                    "mp_fnorm": parse_float(parts[12]),
                }
            )
        except ValueError:
            # Skip lines that don't parse cleanly (e.g., headers)
            continue
    return rows


def parse_titles(path: Path) -> dict[int, str]:
    txt = path.read_text()
    titles = {}
    # Find each pNN_title block and grab the assigned string.
    for match in re.finditer(r"subroutine\s+p(\d{2})_title.*?title\s*=\s*'([^']*)'", txt, flags=re.IGNORECASE | re.DOTALL):
        prob = int(match.group(1))
        titles[prob] = match.group(2).strip()
    return titles


def main():
    exe = Path(__file__).resolve().parents[2] / "build" / "run_test_nonlin"
    titles_path = Path(__file__).resolve().parent / "test_nonlin.f90"
    if not exe.exists():
        print(f"Executable not found: {exe}. Build it with cmake --build build.", file=sys.stderr)
        sys.exit(1)
    titles = parse_titles(titles_path) if titles_path.exists() else {}

    result = subprocess.run([str(exe)], capture_output=True, text=True, check=True)
    rows = parse_table(result.stdout)
    if not rows:
        print("No rows parsed; check the run_test_nonlin output.", file=sys.stderr)
        sys.exit(1)

    problems = [r["problem"] for r in rows]
    labels = [f"{p}: {titles.get(p, '')}".strip().rstrip(":") for p in problems]
    tr_time = [r["tr_time"] for r in rows]
    mp_time = [r["mp_time"] for r in rows]
    tr_f = [r["tr_fnorm"] for r in rows]
    mp_f = [r["mp_fnorm"] for r in rows]
    tr_ret = [r["tr_ret"] for r in rows]
    mp_ret = [r["mp_ret"] for r in rows]

    x = range(len(problems))
    width = 0.4

    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 8), sharex=True)

    tr_colors = ["#4c72b0" if r == 0 else "#c44e52" for r in tr_ret]
    mp_colors = ["#55a868" if r == 1 else "#c44e52" for r in mp_ret]

    ax1.bar([i - width / 2 for i in x], tr_time, width, label="TrustRegion", color=tr_colors)
    ax1.bar([i + width / 2 for i in x], mp_time, width, label="MINPACK hybrj1", color=mp_colors)
    ax1.set_ylabel("avg time (s)")
    ax1.set_yscale("log")
    ax1.legend()
    ax1.grid(True, axis="y", alpha=0.3)

    ax2.bar([i - width / 2 for i in x], tr_f, width, label="TrustRegion", color=tr_colors)
    ax2.bar([i + width / 2 for i in x], mp_f, width, label="MINPACK hybrj1", color=mp_colors)
    ax2.set_ylabel("||f(u)||")
    ax2.set_xlabel("problem")
    ax2.set_xticks(list(x))
    ax2.set_xticklabels(labels, rotation=60, ha="right", fontsize=8)
    ax2.set_yscale("log")
    ax2.grid(True, axis="y", alpha=0.3)

    fig.tight_layout()
    outpath = Path(__file__).with_suffix(".png")
    fig.savefig(outpath, dpi=200)
    print(f"Wrote {outpath}")


if __name__ == "__main__":
    main()
