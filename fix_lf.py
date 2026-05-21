import os

def fix_lf(path):
    try:
        with open(path, 'rb') as f:
            content = f.read()
        if b'\r\n' in content:
            with open(path, 'wb') as f:
                f.write(content.replace(b'\r\n', b'\n'))
            print(f"Fixed CRLF to LF: {path}")
    except Exception as e:
        pass

for root, _, files in os.walk('airootfs'):
    for file in files:
        fix_lf(os.path.join(root, file))
