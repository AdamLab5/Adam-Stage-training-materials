import sys
import re

def prepareDoc2():
    with open(sys.argv[1], "r", encoding="utf-8") as f:
        content = f.read()

    content = re.sub(
        r'\\setupdemoframe\s*\{([^{}]*)\}\s*\{([\s\S]*?)\}',
        r'#setupdemoframe("\1",\n"\2"\n)',
        content
    )

    content = re.sub(
        r'\\begin\{frame\}\{([^}]*)\}',
        r'=== \1',
        content
    )
    content = content.replace(r'\\end{frame}', '')

    content = content.replace(r'\\begin{itemize}', '')
    content = content.replace(r'\\end{itemize}', '')
    content = re.sub(r'\\item\s+', '- ', content)

    content = re.sub(
        r'\\code\{([^}]*)\}',
        r'```\1```',
        content
    )

    content = re.sub(r'\\[a-zA-Z]+\{([^}]*)\}', r'\1', content)

    content = re.sub(r'\\[a-zA-Z]+', '', content)

    content = re.sub(r'\n\s*\n\s*\n+', '\n\n', content)

    content = content.replace('{', '')
    content = content.replace('}', '')

    with open(sys.argv[2], "w", encoding="utf-8") as f:
        f.write(content)

if __name__ == "__main__":
     prepareDoc2()