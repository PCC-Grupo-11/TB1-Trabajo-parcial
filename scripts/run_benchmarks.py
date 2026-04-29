#!/usr/bin/env python3
"""
Run the benchmark binary across combinations of workers and buffer multipliers.

Assuming the binary is already built at ./benchmark (or ./benchmark.exe on Windows),
this script runs it for a fixed set of 25 runs: 24 concurrent combinations plus one
sequential run. It prints progress in the console and copies the produced JSON report
with a descriptive filename.
"""
import os
import re
import shutil
import subprocess
from datetime import datetime
from pathlib import Path

DEFAULT_WORKERS = [1, 2, 4, 8, 16, 32]
DEFAULT_BUFFERS = [5, 20, 50, 100]
DEFAULT_INPUT = "data/cleaned_dataset.csv"
DEFAULT_N = 20
DEFAULT_BINARY = "./benchmark"

def extract_json_path(output_text):
    m = re.search(r"JSON file:\s*(.+)", output_text)
    if m:
        return m.group(1).strip()
    return None

def run_and_capture(binary, mode, n, workers, buffer_multiplier):
    cmd = [binary, "--mode", mode, "-n", str(n), "--input", DEFAULT_INPUT]

    if mode == "concurrent":
        cmd += ["-w", str(workers), "-b", str(buffer_multiplier)]

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

    binary = DEFAULT_BINARY + (".exe" if os.name == "nt" else "")

    combos = []
    for w in DEFAULT_WORKERS:
        for b in DEFAULT_BUFFERS:
            combos.append(("concurrent", w, b))
    combos.append(("sequential", -1, -1))

    summary = []
    total_runs = len(combos)
    for index, (mode, w, b) in enumerate(combos, start=1):
        print(f"\n=== Run {index}/{total_runs}: {mode} ===")
        rc = run_and_capture(binary, mode, DEFAULT_N, w, b)
        summary.append({"mode": mode, "workers": w, "buffer": b, "rc": rc})

    print("\nAll runs finished. Summary:")
    for s in summary:
        print(s)


if __name__ == "__main__":
    main()
