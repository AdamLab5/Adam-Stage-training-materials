import sys
import re



def testRefixPost():
    with open(sys.argv[1], "r") as f_In, open(sys.argv[2], 'w') as f_Out:
        document = f_In.read()
        document = re.sub(
            r'(-[^-]*)\n\s*([^-]*)',
            r'\1 \2',
            document
        )
        f_Out.write(document)


if __name__ == "__main__":
    testRefixPost()