import sys
import re


def prepareDoc():
          with open(sys.argv[1], "r") as f_In1, open(sys.argv[2], "w") as f_Out1:
            patternSetupDemoFrame = r'''\\setupdemoframe\s*\{([^}]*)\}\s*\{([^}]*)\}'''
            document = f_In1.read()
            document = re.sub(
            r'\\setupdemoframe\s*\{([^}]*)\}\s*\{([\s\S]*?)\}',
            r'#setupdemoframe("\1","\2")',
            document
        )
            f_Out1.write(document)
          with open(sys.argv[2], "r") as f_In2, open(sys.argv[3], "w") as f_Out2:
            for ligne in f_In2: 

                if "\\begin" in ligne and "itemize" in ligne:
                    continue
                if """\\end{itemize}""" in ligne:
                    continue
                nv_ligne = ligne.replace("\\end{frame}", "")
                nv_ligne = re.sub(r'\\code\{([^}]*)\}', r'``` \1 ```', nv_ligne)
                nv_ligne = nv_ligne.replace("\\code{", "```")
                if "\\" not in nv_ligne and "\\end" not in nv_ligne and "\\begin" not in nv_ligne and "{" not in nv_ligne :
                    nv_ligne = nv_ligne.replace("}", "```")
                if "\\begin{frame}" in nv_ligne:
                     nv_ligne = nv_ligne.replace("\\begin{frame}", "=== ")
                     nv_ligne = nv_ligne.replace("{", "")
                     nv_ligne = nv_ligne.replace("}", "")
                if nv_ligne.startswith("```") and nv_ligne.endswith("```") :
                    nv_ligne = nv_ligne.replace("```", """")""")
                f_Out2.write(nv_ligne)
            f_In1.close()
            f_Out1.close()
            f_In2.close()
            f_Out2.close()
            with open(sys.argv[3], "r") as f_In3, open(sys.argv[2], "w") as f_Out3:
                for ligne in f_In3:
                    f_Out3.write(ligne)

# def prepareDoc():
#     with open(sys.argv[1], "r") as f_In:
#         content = f_In.read()
#         content = re.sub(
#             r'\\setupdemoframe\s*\{([^}]*)\}\s*\{([\s\S]*?)\}',
#             r'#setupdemoframe("\1",\2)',
#             content
#         )

#         content = re.sub(r'\\code\{([^}]*)\}', r'```\1```', content)

#         content = re.sub(r'\\begin\{frame\}\{([^}]*)\}', r'=== \1', content)

#         content = content.replace("\\end{frame}", "")

#     with open(sys.argv[2], "w") as f_Out:
#         f_Out.write(content)

# def prepareDoc():
#     with open(sys.argv[1], "r", encoding="utf-8") as f:
#         content = f.read()

#     content = re.sub(
#         r'\\setupdemoframe\s*\{([^{}]*)\}\s*\{([\s\S]*?)\}',
#         r'#setupdemoframe("\1",\n"\2"\n)',
#         content
#     )

#     content = re.sub(
#         r'\\begin\{frame\}\{([^}]*)\}',
#         r'=== \1',
#         content
#     )
#     content = content.replace(r'\\end{frame}', '')

#     content = content.replace(r'\\begin{itemize}', '')
#     content = content.replace(r'\\end{itemize}', '')
#     content = re.sub(r'\\item\s+', '- ', content)

#     content = re.sub(
#         r'\\code\{([^}]*)\}',
#         r'```\1```',
#         content
#     )

#     content = re.sub(r'\\[a-zA-Z]+\{([^}]*)\}', r'\1', content)

#     content = re.sub(r'\\[a-zA-Z]+', '', content)

#     content = re.sub(r'\n\s*\n\s*\n+', '\n\n', content)

#     content = content.replace('{', '')
#     content = content.replace('}', '')

#     with open(sys.argv[2], "w", encoding="utf-8") as f:
#         f.write(content)















# import sys
# import re


# def prepareDoc():
#           with open(sys.argv[1], "r") as f_In, open(sys.argv[2], "w") as f_Out:
#             for ligne in f_In:
#                 nv_ligne = ligne.replace("\\end{frame}", "")
#                 nv_ligne = re.sub(r'\\code\{([^}]*)\}', r'```\1```', nv_ligne)
#                 nv_ligne = nv_ligne.replace("\\code{", "```")
#                 if "\\" not in nv_ligne and "\\end" not in nv_ligne and "\\begin" not in nv_ligne :
#                     nv_ligne = nv_ligne.replace("}", "```")
#                 if "\\begin{frame}" in nv_ligne:
#                      nv_ligne = nv_ligne.replace("\\begin{frame}", "=== ")
#                      nv_ligne = nv_ligne.replace("{", "")
#                      nv_ligne = nv_ligne.replace("}", "")
#                 f_Out.write(nv_ligne)
# if __name__ == "__main__":
#      prepareDoc()

if __name__ == "__main__":
     prepareDoc()