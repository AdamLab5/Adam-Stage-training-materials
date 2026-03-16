import subprocess



# A RETRAVAILLER : Verbatim

def testPandoc():
    
    with open("boot-time2.tex", "r") as f_In, open("boot-timeMD.md","w") as f_Out:

        subprocess.run(["pandoc", "-s", "boot-time2.tex", "-o", "boot-timeMD.md"])


def testLateX():
    with open("boot-time.tex", "r") as f_In, open("boot-time2.tex", "w") as f_Out:
        for ligne in f_In:
            if "verbatim" in ligne:
                ligne = ligne.replace(ligne, "```\n")
            
            if "{itemize}" in ligne:
                continue

            if "\\item" in ligne:
                ligne = ligne.replace("\\item", " - ")

            if "\\code" in ligne:
                nv_ligne = ligne.replace("\\code", "```")
                nv_ligne = nv_ligne.replace("{", "")
                nv_ligne = nv_ligne.replace("}", "```")
                f_Out.write(nv_ligne)
            else :
                f_Out.write(ligne)


def Relecture():
    with open("boot-timeMD.md", "r") as f_In, open("boot-timeMD2.md", "w") as f_Out:
        for ligne in f_In:
            
            if ":::" in ligne:
                continue
            else:
                if """"'""" in ligne:
                    nv_ligne = ligne.replace(""""'""", "```")
                    f_Out.write(nv_ligne)
                else:
                    f_Out.write(ligne)
            




if __name__ == "__main__":
    testLateX()
    testPandoc()
    Relecture()