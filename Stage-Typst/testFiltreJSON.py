#!/usr/bin/env python3

import sys
import re

def main():
    try:
        for ligne in sys.stdin:
            ligne = ligne.replace("“‘", "```")
            ligne = ligne.replace("\\", "")
            sys.stdout.write(ligne)
    except Exception:
        sys.exit(1)

if __name__ == "__main__":
    main()