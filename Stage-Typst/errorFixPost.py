#!/usr/bin/env python3
import sys
import re
import subprocess
import os
from pathlib import Path
from typing import Self


def relecture():
    patternImg = re.compile(r'#image\("([^"]+)"')

    for ligne in sys.stdin:
        
        match = patternImg.search(ligne)
        if match:
            path = match.group(1)
            filename = Path(path).name
            path2 = Path(path)
            if Path(path2).exists():
                ligne = ligne.replace(path, filename)
            else:
                ligne = ligne.replace('''#image("common/''', """#image("../../out/common/""")
                ligne = ligne.replace('''#image("slides/''', """#image("../../out/slides/""")

            match = patternImg.search(ligne)

        ligne.replace("\\]", "]")
        if match:
            path = match.group(1)
            path_obj = Path(path)
            filename = path_obj.stem

            # svg_same_dir = path_obj.with_suffix(".svg")
            # svg_out_dir = Path("../../out") / (filename + ".svg")

            # if path_obj.exists():
            #     ligne = ligne.replace(path, path_obj.name)

            # else:
            #     ligne = ligne.replace('#image("common/', '#image("../../out/common/')
            #     ligne = ligne.replace('#image("slides/', '#image("../../out/slides/')

            #     if path_obj.suffix == ".pdf":
                    
            #         if svg_same_dir.exists():
            #             subprocess.run(["inkscape ", "-D", "-o", str(svg_same_dir), " --export-type=pdf"])
                    
            #         elif svg_out_dir.exists():
            #             subprocess.run(["inkscape ", "-D", "-o", str(svg_out_dir), " --export-type=pdf"])

            dia_same_dir = path_obj.with_suffix(".dia")
            eps_same_dir = path_obj.with_suffix(".eps")
            pdf_same_dir = path_obj.with_suffix(".pdf")
            dia_out_dir = Path("../../out") / (filename + ".dia")
            eps_out_dir = Path("../../out") / (filename + ".eps")
            pdf_out_dir = Path("../../out") / (filename + ".pdf")

            if path_obj.exists():
                ligne = ligne.replace(path, path_obj.name)

            else:
                ligne = ligne.replace('#image("common/', '#image("../../out/common/')
                ligne = ligne.replace('#image("slides/', '#image("../../out/slides/')

                if path_obj.suffix == ".pdf":
                    
                    if dia_same_dir.exists():
                        ligne = ligne.replace(path, filename)
                        subprocess.run(["dia", "-e", str(eps_same_dir), "-t", "eps", str(dia_same_dir)])
                        subprocess.run(["epstopdf", "--outfile="+str(pdf_same_dir), str(eps_same_dir)])
                    
                    
                    elif dia_out_dir.exists():
                        subprocess.run(["dia", "-e", str(eps_out_dir), "-t", "eps", str(dia_out_dir)])
                        subprocess.run(["epstopdf", "--outfile="+str(pdf_out_dir), str(eps_out_dir)])
                    
                    else:
                        # I'm here
                        print("A")

                        
            # jpg_same_dir = path_obj.with_suffix(".jpg")
            # jpg_out_dir = Path("../../out") / (filename + ".jpg")

            # if path_obj.exists():
            #     ligne = ligne.replace(path, path_obj.name)

            # else:
            #     ligne = ligne.replace('#image("common/', '#image("../../out/common/')
            #     ligne = ligne.replace('#image("slides/', '#image("../../out/slides/')

            #     if path_obj.suffix == ".pdf":
                    
            #         if svg_same_dir.exists():
            #             subprocess.run(["inkscape ", "-D", "-o", str(jpg_same_dir), " --export-type=pdf"])
                    
            #         elif svg_out_dir.exists():
            #             subprocess.run(["inkscape ", "-D", "-o", str(jpg_out_dir), " --export-type=pdf"])
        
        ligne = ligne.replace("""“‘""", "```")
        ligne = ligne.replace("\\[fragile\\]", "")
        if ligne.startswith("\\section"):
            ligne = ligne.replace("\\section{", "= ")
            ligne = ligne.replace("}", "")
        if ligne.startswith("\\subsection{"):
            ligne = ligne.replace("\\subsection{", "== ")
            ligne = ligne.replace("}", "")
        if ligne.startswith("= "):
            ligne = ligne.replace("=", """#import "@local/bootlin:0.1.0": *\n#import "@local/bootlin-yocto:0.1.0": *\n#import "@local/bootlin-utils:0.1.0": *\n#import "../../typst/local/themeBootlin.typ": *\n#import "../../typst/local/common.typ": *\n#show: bootlin-theme.with(\n  aspect-ratio: "16-9",\n\nconfig-common(\n  // Compile with `typst c --input handout=1 ...` to generate the handout.\n  handout: "handout" in sys.inputs and sys.inputs.handout == "1",\n))\n#show raw.where(block: true): set block(fill: luma(240), inset: 1em, radius:0.5em, width:100%)\n#show raw.where(block: false): r => { text(fill: color-link)[#r] } \n\n=""")
        
        ligne = ligne.replace("\\=\\=\\=", "=== ")
        if "```make" in ligne :
            ligne = ligne.replace("```make", "``` make")
        
        if "\\" in ligne:
            ligne = ligne.replace("\\", "")
        if "#image" in ligne:
                nv_ligne = ligne.replace("textheight", "0%")
                nv_ligne = nv_ligne.replace("0.", "")

                nv_ligne = nv_ligne.replace("textwidth", "100%")   
                if "www.png" in ligne:
                    nv_ligne = nv_ligne.replace("textwidth", "50%")
                    nv_ligne = nv_ligne.replace("70%", "50%")
                if "bootlin-logo.pdf" in ligne:
                    nv_ligne = nv_ligne.replace("100%", "15%")
                nv_ligne = nv_ligne.replace("#image", "#align(center, [#image")
                nv_ligne = nv_ligne.replace("%)", "%)])")
                nv_ligne = nv_ligne.replace("cm)", "cm)])")
                
                sys.stdout.write(nv_ligne)
        

        else:
            sys.stdout.write(ligne)


if __name__ == "__main__":
    relecture()










# #!/usr/bin/env python3
# import sys
# import re
# import subprocess
# from pathlib import Path


# def relecture():
#     patternImg = re.compile(r'#image\("([^"]+)"')

#     for ligne in sys.stdin:
        

#         match = patternImg.search(ligne)
#         if match:
#             path = match.group(1)
#             filename = Path(path).name
#             ligne = ligne.replace(path, filename)
        
#         ligne = ligne.replace("""“‘""", "```")
#         ligne = ligne.replace("\\[fragile\\]", "")
#         if ligne.startswith("== "):
#             ligne = ligne.replace("== ", "= ")
#         if ligne.startswith("= "):
#             ligne = ligne.replace("=", """#import "@local/bootlin:0.1.0": *\n#import "@local/bootlin-yocto:0.1.0": *\n#import "@local/bootlin-utils:0.1.0": *\n\n#show: bootlin-theme.with(\n  aspect-ratio: "16-9",\n\nconfig-common(\n  // Compile with `typst c --input handout=1 ...` to generate the handout.\n  handout: "handout" in sys.inputs and sys.inputs.handout == "1",\n))\n#show raw.where(block: true): set block(fill: luma(240), inset: 1em, radius:0.5em, width:100%)\n#show raw.where(block: false): r => { text(fill: color-link)[#r] } \n\n=""")
        
#         ligne = ligne.replace("\\=\\=\\=", "=== ")

#         if "```make" in ligne :
#             ligne = ligne.replace("```make", "``` make")
        

#         if "textheight" in ligne or "textwidth" in ligne:
#             if "#image" in ligne:
#                 nv_ligne = ligne.replace("\\textheight", "0%")
#                 nv_ligne = nv_ligne.replace("0.", "")
#                 nv_ligne = nv_ligne.replace("\\textwidth", "100%")
#                 sys.stdout.write(nv_ligne)
#         else:
#             sys.stdout.write(ligne)


# if __name__ == "__main__":
#     relecture()



# if __name__ == "__main__":
#     relecture()