#!/usr/bin/env python3
import sys
import os

def findPath():
    for ligne in sys.stdin:
        if "\\code" in ligne:
            nv_ligne = ligne.replace("\\code", "```")
            sys.stdout.write(nv_ligne)
        else:
            sys.stdout.write(ligne)

        if ligne.

if __name__ == "__main__":
    findPath()