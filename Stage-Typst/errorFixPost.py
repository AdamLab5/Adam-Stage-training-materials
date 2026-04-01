#!/usr/bin/env python3
import sys
import re
import subprocess
import os
from pathlib import Path
from typing import Self

def resolve_image(path_str, ligne):
    path_obj = Path(path_str)
    filename = path_obj.stem
    suffix = path_obj.suffix

    out_dir = Path("../../out")
    out_common_dir = Path("../../out/common")
   
    def try_convert_svg(svg_path, pdf_path):
        """Convertit svg -> pdf via inkscape"""
        subprocess.run(["inkscape", "--export-filename=" + str(pdf_path), str(svg_path)])
        return pdf_path

    def try_convert_dia(dia_path, pdf_path):
        """Convertit dia -> eps -> pdf"""
        eps_path = dia_path.with_suffix(".eps")
        subprocess.run(["dia", "-e", str(eps_path), "-t", "eps", str(dia_path)])
        subprocess.run(["epstopdf", "--outfile=" + str(pdf_path), str(eps_path)])
        return pdf_path

    pdf_same = path_obj.with_suffix(".pdf")
    pdf_out  = out_dir / (filename + ".pdf")
    pdf_out_common = out_common_dir / (filename + ".pdf")

    svg_same = path_obj.with_suffix(".svg")
    svg_out  = out_dir / (filename + ".svg")

    dia_same = path_obj.with_suffix(".dia")
    dia_out  = out_dir / (filename + ".dia")

    if pdf_out_common.exists():
        ligne = ligne.replace(path_str, str(pdf_out_common))
        
    if path_obj.exists():
        return ligne.replace(path_str, path_obj.name)

    if svg_same.exists() and not pdf_same.exists():
        try_convert_svg(svg_same, pdf_same)

    elif svg_out.exists() and not pdf_out.exists():
        try_convert_svg(svg_out, pdf_out)

    elif dia_same.exists() and not pdf_same.exists():
        try_convert_dia(dia_same, pdf_same)

    elif dia_out.exists() and not pdf_out.exists():
        try_convert_dia(dia_out, pdf_out)
    

    if pdf_same.exists():
        return ligne.replace(path_str, str(pdf_same))
    elif pdf_out.exists():
        return ligne.replace(path_str, str(pdf_out))
   
    return ligne






def relecture():
    patternImg = re.compile(r'#image\("([^"]+)"')

    for ligne in sys.stdin:
        
        match = patternImg.search(ligne)
        if match:
            path = match.group(1)
            ligne = resolve_image(path, ligne)
            match = patternImg.search(ligne)  # re-check après modification
        #     path = match.group(1)
        #     filename = Path(path).name
        #     path2 = Path(path)
        #     if Path(path2).exists():
        #         ligne = ligne.replace(path, filename)
        #     else:
        #         ligne = ligne.replace('''#image("common/''', """#image("../../out/common/""")
        #         ligne = ligne.replace('''#image("slides/''', """#image("../../out/slides/""")

        #     match = patternImg.search(ligne)

        # ligne.replace("\\]", "]")
        # if match:
        #     path = match.group(1)
        #     path_obj = Path(path)
        #     filename = path_obj.stem

        #     # svg_same_dir = path_obj.with_suffix(".svg")
        #     # svg_out_dir = Path("../../out") / (filename + ".svg")

        #     # if path_obj.exists():
        #     #     ligne = ligne.replace(path, path_obj.name)

        #     # else:
        #     #     ligne = ligne.replace('#image("common/', '#image("../../out/common/')
        #     #     ligne = ligne.replace('#image("slides/', '#image("../../out/slides/')

        #     #     if path_obj.suffix == ".pdf":
                    
        #     #         if svg_same_dir.exists():
        #     #             subprocess.run(["inkscape ", "-D", "-o", str(svg_same_dir), " --export-type=pdf"])
                    
        #     #         elif svg_out_dir.exists():
        #     #             subprocess.run(["inkscape ", "-D", "-o", str(svg_out_dir), " --export-type=pdf"])

        #     dia_same_dir = path_obj.with_suffix(".dia")
        #     eps_same_dir = path_obj.with_suffix(".eps")
        #     pdf_same_dir = path_obj.with_suffix(".pdf")
        #     dia_out_dir = Path("../../out") / (filename + ".dia")
        #     eps_out_dir = Path("../../out") / (filename + ".eps")
        #     pdf_out_dir = Path("../../out") / (filename + ".pdf")

        #     if path_obj.exists():
        #         ligne = ligne.replace(path, path_obj.name)

        #     else:
        #         ligne = ligne.replace('#image("common/', '#image("../../out/common/')
        #         ligne = ligne.replace('#image("slides/', '#image("../../out/slides/')

        #         if path_obj.suffix == ".pdf":
                    
        #             if dia_same_dir.exists():
        #                 ligne = ligne.replace(path, filename)
        #                 subprocess.run(["dia", "-e", str(eps_same_dir), "-t", "eps", str(dia_same_dir)])
        #                 subprocess.run(["epstopdf", "--outfile="+str(pdf_same_dir), str(eps_same_dir)])
                    
                    
        #             elif dia_out_dir.exists():
        #                 subprocess.run(["dia", "-e", str(eps_out_dir), "-t", "eps", str(dia_out_dir)])
        #                 subprocess.run(["epstopdf", "--outfile="+str(pdf_out_dir), str(eps_out_dir)])
                    
        #             else:
        #                 # I'm here
        #                 print("A")

                        
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


            # with 
        
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
        
        # lines = sys.stdin.split('\n')
        # result = []
        # prev_was_item = False

        # for line in lines:
        #     is_item = line.strip().startswith(r'\item')
        
        #     if line.strip() == '' and prev_was_item:
        #         continue
        
        #     result.append(line)
        #     prev_was_item = is_item

        # output = '\n'.join(result)

        ligne = re.sub(r'\$([A-Za-z_][A-Za-z0-9_]*|\d+)', r'\\$\1', ligne)
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