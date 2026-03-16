import re


### Version presque correcte, petits soucis par moments, tels que des underscores qui ne sont pas fermés (italiques) mais affichage assez correcte lors du test Typst
### Il faudra surement réajuster pour les slides de diaporama
def testCode():
    with open("test1LateX.tex", "r") as f_In, open("test1Typst.typ", "w") as f_Out:
        for ligne in f_In:
            if "documentclass" in ligne or "\\institute" in ligne or "\\begin" in ligne or "\\end" in ligne:
                continue
            
            
            nv_ligne = ligne.replace("\\section", "= ")
            nv_ligne = nv_ligne.replace("\\subsection", "== ")
            if "\\emph" in nv_ligne:
                nv_ligne = nv_ligne.replace("\\emph", "_")
                nv_ligne = nv_ligne.replace("}", "_") 
            nv_ligne = nv_ligne.replace("\\item", "- ")
            nv_ligne = nv_ligne.replace("\\frametitle", "= ")
            nv_ligne = nv_ligne.replace("\\enditemize", "")
            nv_ligne = nv_ligne.replace("{", " ")
            nv_ligne = nv_ligne.replace("}", " ")
                
            
            f_Out.write(nv_ligne)

if __name__ == "__main__":
    testCode()