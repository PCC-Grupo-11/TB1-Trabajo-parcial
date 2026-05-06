#!/usr/bin/env python3
"""
Run the concurrent and sequential binaries across combinations of workers.

Assuming the binaries are already built at ./bin/concurrent and ./bin/sequential
(or .exe on Windows), this script runs it for a fixed set of concurrent
combinations plus one sequential run.
It prints progress in the console and copies the produced JSON report with a
descriptive filename.
"""
import os
import re
import subprocess
from pathlib import Path

DEFAULT_WORKERS = [1, 2, 4, 8, 12, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256]
DEFAULT_INPUT = "data/cleaned_dataset.csv"
DEFAULT_N = 20


def executable_path(mode):
    extension = ".exe" if os.name == "nt" else ""
    return Path("bin") / f"{mode}{extension}"

def extract_json_path(output_text):
    m = re.search(r"JSON file:\s*(.+)", output_text)
    if m:
        return m.group(1).strip()
    return None

def run_and_capture(mode, n, workers):
    binary = executable_path(mode)
    if not binary.exists():
        print(f"error: executable not found: {binary}")
        return 127

    cmd = [str(binary), "-n", str(n), "--input", DEFAULT_INPUT]

    if mode == "concurrent":
        cmd += ["-w", str(workers)]

    print("\n==> Running:", " ".join(cmd))
    proc = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)

    print(proc.stdout, end="")

    json_path = extract_json_path(proc.stdout)
    if json_path:
        if not Path(json_path).exists():
            print(f"warning: JSON file reported ({json_path}) not found on disk")
    else:
        print("warning: JSON file path not found in program output")

    return proc.returncode

def main():
    results_dir = Path("results")
    results_dir.mkdir(exist_ok=True)

    combos = []
    for w in DEFAULT_WORKERS:
        combos.append(("concurrent", w))
    combos.append(("sequential", -1))

    summary = []
    total_runs = len(combos)
    for index, (mode, w) in enumerate(combos, start=1):
        print(f"\n=== Run {index}/{total_runs}: {mode} ===")
        rc = run_and_capture(mode, DEFAULT_N, w)
        summary.append({"mode": mode, "workers": w, "rc": rc})

    print("\nAll runs finished. Summary:")
    for s in summary:
        print(s)


if __name__ == "__main__":
    main()
