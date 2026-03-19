# import sys
# import re


# def prepareDoc():
          
#           with open(sys.argv[1], "r") as f_In1, open(sys.argv[2], "w") as f_Out1:
              
#           with open(sys.argv[1], "r") as f_In1, open(sys.argv[2], "w") as f_Out1:
#             patternSetupDemoFrame = r'''\\setupdemoframe\s*\{([^}]*)\}\s*\{([^}]*)\}'''
#             document = f_In1.read()
#             document = re.sub(
#             r'\\setupdemoframe\s*\{([^}]*)\}\s*\{([\s\S]*?)\}',
#             r'#setupdemoframe([\1],[\2])',
#             document
#         )
#             f_Out1.write(document)
#           with open(sys.argv[2], "r") as f_In2, open(sys.argv[3], "w") as f_Out2:
#             for ligne in f_In2: 

#                 nv_ligne = ligne.replace("\\end{frame}", "")
#                 nv_ligne = re.sub(r'\\code\{([^}]*)\}', r'``` \1 ```', nv_ligne)
#                 nv_ligne = nv_ligne.replace("\\code{", "```")
#                 if "\\" not in nv_ligne and "\\end" not in nv_ligne and "\\begin" not in nv_ligne and "{" not in nv_ligne :
#                     nv_ligne = nv_ligne.replace("}", "```")
#                 if "\\begin{frame}" in nv_ligne:
#                      nv_ligne = nv_ligne.replace("\\begin{frame}", "=== ")
#                      nv_ligne = nv_ligne.replace("{", "")
#                      nv_ligne = nv_ligne.replace("}", "")
#                 if nv_ligne.startswith("```") and nv_ligne.endswith("```") :
#                     nv_ligne = nv_ligne.replace("```", """")""")
#                 f_Out2.write(nv_ligne)
#             f_In1.close()
#             f_Out1.close()
#             f_In2.close()
#             f_Out2.close()
#             with open(sys.argv[3], "r") as f_In3, open(sys.argv[2], "w") as f_Out3:
#                 for ligne in f_In3:
#                     f_Out3.write(ligne)





# if __name__ == "__main__":
#      prepareDoc()



import sys
import re


def prepareDoc():

    with open(sys.argv[1], "r") as f_In, open(sys.argv[2], "w") as f_Out:
        document = f_In.read()
        document = re.sub(
            r'\\begin{frame}',
            r'=== ',
            document
        )

        document = re.sub(
            r'\\end{frame}',
            r'',
            document
        )

        document = re.sub(
            r'\\code\{([^}]*)\}',
            r'``` \1 ```',
            document
        )

        document = re.sub(
            r'\\end\s*{([^}])}',
            r'',
            document
        )

        document = re.sub(
            r'\\setupdemoframe\s*\{([^}]*)\}\s*\{([\s\S]*?\\end\{itemize\}[\s\S]*?)\}',
            r'#setupdemoframe([\1],[\2])',
            document
        )
        f_Out.write(document)


if __name__ == "__main__":
    prepareDoc()
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





# #!/usr/bin/env python3
# import sys
# import re


# def convert_itemize(content: str) -> str:
#     """Convertit récursivement les blocs itemize/enumerate en listes Typst."""
#     def replace_block(m):
#         inner = m.group(1)
#         inner = convert_itemize(inner) # récursion pour les nested lists
#         inner = re.sub(r'\\item\s*', '- ', inner)
#         return inner

#     content = re.sub(
#         r'\\begin\{itemize\}([\s\S]*?)\\end\{itemize\}',
#         replace_block,
#         content
#     )
#     content = re.sub(
#         r'\\begin\{enumerate\}([\s\S]*?)\\end\{enumerate\}',
#         replace_block,
#         content
#     )
#     return content


# def convert_frame(m) -> str:
#     """Convertit un \\begin{frame}{Titre} ... \\end{frame} en slide Typst."""
#     title = m.group(1).strip()
#     body = m.group(2)
#     body = convert_itemize(body)
#     body = apply_inline(body)
#     return f"== {title}\n{body.strip()}\n"


# def apply_inline(content: str) -> str:
#     """Applique les substitutions inline (code, url, links...)."""
#     # \code{foo} → `foo`
#     content = re.sub(r'\\code\{([^}]*)\}', r'`\1`', content)
#     # \url{...} → #link("...")
#     content = re.sub(r'\\url\{([^}]*)\}', r'#link("\1")', content)
#     # \textbf{...} → *...*
#     content = re.sub(r'\\textbf\{([^}]*)\}', r'*\1*', content)
#     # \textit{...} / \emph{...} → _..._
#     content = re.sub(r'\\(?:textit|emph)\{([^}]*)\}', r'_\1_', content)
#     return content


# def convert_setupdemoframe(m) -> str:
#     title = m.group(1).strip()
#     body = m.group(2)
#     body = convert_itemize(body)
#     body = apply_inline(body)
#     # Indente chaque ligne du body pour la lisibilité
#     indented = "\n".join(" " + l for l in body.strip().splitlines())
#     return f'#setupdemoframe(\n [{title}],\n [\n{indented}\n ]\n)'


# def convert_setuplabframe(m) -> str:
#     title = m.group(1).strip()
#     body = m.group(2)
#     body = convert_itemize(body)
#     body = apply_inline(body)
#     indented = "\n".join(" " + l for l in body.strip().splitlines())
#     return f'#setuplabframe(\n [{title}],\n [\n{indented}\n ]\n)'


# def prepareDoc(input_path: str, output_path: str):
#     with open(input_path, "r", encoding="utf-8") as f:
#         doc = f.read()

#     # 1. setupdemoframe / setuplabframe avant les frames génériques
#     doc = re.sub(
#         r'\\setupdemoframe\s*\{([^}]*)\}\s*\{([\s\S]*?)\}(?=\s*\\|\s*$|\s*#)',
#         convert_setupdemoframe,
#         doc
#     )
#     doc = re.sub(
#         r'\\setuplabframe\s*\{([^}]*)\}\s*\{([\s\S]*?)\}(?=\s*\\|\s*$|\s*#)',
#         convert_setuplabframe,
#         doc
#     )

#     # 2. Frames génériques
#     doc = re.sub(
#         r'\\begin\{frame\}\{([^}]*)\}([\s\S]*?)\\end\{frame\}',
#         convert_frame,
#         doc
#     )

#     # 3. Sections / subsections
#     doc = re.sub(r'\\section\{([^}]*)\}', r'= \1', doc)
#     doc = re.sub(r'\\subsection\{([^}]*)\}', r'== \1', doc)

#     # 4. Inline global (ce qui reste hors frames)
#     doc = apply_inline(doc)

#     # 5. Nettoyage des lignes vides multiples
#     doc = re.sub(r'\n{3,}', '\n\n', doc)

#     with open(output_path, "w", encoding="utf-8") as f:
#         f.write(doc)


# if __name__ == "__main__":
#     if len(sys.argv) != 3:
#         print(f"Usage: {sys.argv[0]} input.tex output.typ")
#         sys.exit(1)
#     prepareDoc(sys.argv[1], sys.argv[2])







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