import subprocess

def transcriptionPandoc():
    with open("testMarkDown4.md", "r") as f_in, open("test1Typst.typ", "w") as f_Out:
        subprocess.run(["pandoc", "testMarkDown4.md", "-o", "test1Typst.typ"])


if __name__ == "__main__":
    transcriptionPandoc()