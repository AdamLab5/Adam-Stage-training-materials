#!/usr/bin/env python3
import sys
import subprocess
from pathlib import Path

BASE_DIR = Path("./slides")

PREP_SCRIPT = Path("./Stage-Typst/prepareCode.py")
POST_SCRIPT = Path("./Stage-Typst/errorFixPost.py")


def run(cmd, input_text=None):
    """Run subprocess safely"""
    return subprocess.run(
        cmd,
        input=input_text,
        text=True,
        capture_output=True,
        check=True
    ).stdout


def main(name: str):
    tex_in = BASE_DIR / name / f"{name}.tex"
    tex_mid = BASE_DIR / name / f"{name}2.tex"
    typ_out = BASE_DIR / name / f"{name}.typ"

    if not tex_in.exists():
        print(f" Input file not found: {tex_in}")
        sys.exit(1)

    print(f" Preparing: {tex_in}")

    # 1. prepareCode.py
    subprocess.run([
        "python3",
        str(PREP_SCRIPT),
        str(tex_in),
        str(tex_mid)
    ], check=True)

    print(f" Running pandoc + post-processing")

    # 2. pandoc | errorFixPost.py
    pandoc = subprocess.Popen(
        ["pandoc", str(tex_mid), "-t", "typst"],
        stdout=subprocess.PIPE,
        text=True
    )

    post = subprocess.run(
        ["python3", str(POST_SCRIPT)],
        stdin=pandoc.stdout,
        text=True,
        capture_output=True,
        check=True
    )

    pandoc.wait()

    # write output
    typ_out.write_text(post.stdout)

    print(f" Generated: {typ_out}")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 build_typst.py <slide-name>")
        sys.exit(1)

    main(sys.argv[1])