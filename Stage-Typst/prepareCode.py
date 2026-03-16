import sys
import re


def prepareDoc():
          with open(sys.argv[1], "r") as f_In, open(sys.argv[2], "w") as f_Out:
            for ligne in f_In:
                nv_ligne = ligne.replace("\\end{frame}", "")
                nv_ligne = re.sub(r'\\code\{([^}]*)\}', r'```\1```', nv_ligne)
                nv_ligne = nv_ligne.replace("\\code{", "```")
                if "\\" not in nv_ligne and "\\end" not in nv_ligne and "\\begin" not in nv_ligne :
                    nv_ligne = nv_ligne.replace("}", "```")
                if "\\begin{frame}" in nv_ligne:
                     nv_ligne = nv_ligne.replace("\\begin{frame}", "=== ")
                     nv_ligne = nv_ligne.replace("{", "")
                     nv_ligne = nv_ligne.replace("}", "")
                f_Out.write(nv_ligne)
if __name__ == "__main__":
     prepareDoc()