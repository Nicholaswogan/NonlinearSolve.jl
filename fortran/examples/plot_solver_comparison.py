#!/usr/bin/env python3
"""
Generate a plot comparing TrustRegion, Newton (with/without backtracking), and
MINPACK hybrj1 on the Burkardt test set.

The script runs the built executable ../../build/run_test_nonlin, parses its table output,
and produces a PNG with grouped bar charts for average runtime and final residual norm.
"""

import re
import subprocess
import sys
from pathlib import Path

import matplotlib.pyplot as plt


def parse_table(text: str):
    rows = []

    def parse_float(val: str) -> float:
        v = val.replace("D", "E")
        try:
            return float(v)
        except ValueError:
            m = re.match(r"^([+-]?\d*\.\d*)([+-]\d+)$", v)
            if m:
                return float(f"{m.group(1)}E{m.group(2)}")
            raise

    for line in text.splitlines():
        if not line.strip():
            continue
        if line.lstrip().startswith("prob") or line.lstrip().startswith("-"):
            continue
        parts = [p.strip() for p in line.split("|")]
        if len(parts) < 11:
            continue
        try:
            rows.append(
                {
                    "problem": int(parts[0]),
                    "n": int(parts[1]),
                    "solver": parts[2],
                    "ret": int(parts[3]),
                    "nf": int(parts[4]),
                    "njac": int(parts[5]),
                    "nsolve": int(parts[6]),
                    "bt": int(parts[7]),
                    "time": parse_float(parts[8]),
                    "fnorm": parse_float(parts[9]),
                    "title": parts[10],
                }
            )
        except ValueError:
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
    raw_rows = parse_table(result.stdout)
    if not raw_rows:
        print("No rows parsed; check the run_test_nonlin output.", file=sys.stderr)
        sys.exit(1)

    # Group by problem -> solver
    grouped = {}
    for r in raw_rows:
        grouped.setdefault(r["problem"], {})[r["solver"]] = r

    solver_order = ["TR", "NR", "NR_BT", "MP"]
    problems = sorted(grouped.keys())
    labels = []
    for p in problems:
        if grouped.get(p) and grouped[p].get("TR"):
            labels.append(f"{p}: {grouped[p]['TR'].get('title','')}".strip().rstrip(":"))
        else:
            labels.append(f"{p}: {titles.get(p, '')}".strip().rstrip(":"))

    def get_or_nan(prob, solver, key):
        entry = grouped.get(prob, {}).get(solver)
        return entry.get(key) if entry else float("nan")

    data = {s: {"time": [], "fnorm": [], "ret": []} for s in solver_order}
    for p in problems:
        for s in solver_order:
            data[s]["time"].append(get_or_nan(p, s, "time"))
            data[s]["fnorm"].append(get_or_nan(p, s, "fnorm"))
            data[s]["ret"].append(get_or_nan(p, s, "ret"))

    x = range(len(problems))
    width = 0.18

    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 8), sharex=True)

    base_colors = {
        "TR": "#4c72b0",
        "NR": "#dd8452",
        "NR_BT": "#55a868",
        "MP": "#9370db",
    }

    def colors_for(solver):
        retcodes = data[solver]["ret"]
        colors = []
        for r in retcodes:
            success = (solver == "MP" and r == 1) or (solver != "MP" and r == 0)
            colors.append(base_colors[solver] if success else "#c44e52")
        return colors

    offsets = {
        "TR": -1.5 * width,
        "NR": -0.5 * width,
        "NR_BT": 0.5 * width,
        "MP": 1.5 * width,
    }

    for solver in solver_order:
        ax1.bar(
            [i + offsets[solver] for i in x],
            data[solver]["time"],
            width,
            label=solver,
            color=colors_for(solver),
        )
    ax1.set_ylabel("avg time (s)")
    ax1.set_yscale("log")
    ax1.legend()
    ax1.grid(True, axis="y", alpha=0.3)

    for solver in solver_order:
        ax2.bar(
            [i + offsets[solver] for i in x],
            data[solver]["fnorm"],
            width,
            label=solver,
            color=colors_for(solver),
        )
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
