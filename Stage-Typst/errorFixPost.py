#!/usr/bin/env python3
import sys
import re
from pathlib import Path

def relecture():
    patternImg = re.compile(r'#image\("([^"]+)"')

    for ligne in sys.stdin:

        match = patternImg.search(ligne)
        if match:
            path = match.group(1)
            filename = Path(path).name
            ligne = ligne.replace(path, filename)
        
        ligne = ligne.replace("""“‘""", "``` ")
        ligne = ligne.replace("\\[fragile\\]", "")
        if ligne.startswith("= "):
            ligne = ligne.replace("=", """#import "@local/bootlin:0.1.0": *\n#import "@local/bootlin-yocto:0.1.0": *\n#import "@local/bootlin-utils:0.1.0": *\n\n#show: bootlin-theme.with(\n  aspect-ratio: "16-9",\n  config-info(\n  title: [#text(size: 0.9em)[Yocto Project and OpenEmbedded:\\ Recent Changes and Future Directions]],\n  author: [#v(-30pt)#text(size: 0.8em)[Antonin Godard\\ _antonin.godard\\@bootlin.com_]],\n  date: [#v(-30pt)#text(size: 0.8em)[Embedded Recipes 2025]],\n  institution: [Bootlin],\n),\nconfig-common(\n  // Compile with `typst c --input handout=1 ...` to generate the handout.\n  handout: "handout" in sys.inputs and sys.inputs.handout == "1",\n))\n \n#show raw.where(block: false): r => { text(fill: color-link)[#r] } \n =""")
        ligne = ligne.replace("\\=\\=\\=", "=== ")


        if "height" in ligne or "width" in ligne:
            if "#image" in ligne:
                nv_ligne = ligne.replace("\\textheight", "0%")
                nv_ligne = nv_ligne.replace("0.", "")
                nv_ligne = nv_ligne.replace("\\textwidth", "100%")
                sys.stdout.write(nv_ligne)
        else:
            sys.stdout.write(ligne)


if __name__ == "__main__":
    relecture()