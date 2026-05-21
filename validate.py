import os

errors = 0

def check_duplicates(file_path):
    global errors
    with open(file_path, 'r') as f:
        lines = [line.strip() for line in f if line.strip() and not line.startswith('#')]
    
    seen = set()
    for line in lines:
        if line in seen:
            print(f"ERROR: Duplicate package '{line}' in {file_path}")
            errors += 1
        seen.add(line)

check_duplicates('packages.x86_64')
check_duplicates('packages.aur')

for root, _, files in os.walk('airootfs'):
    for file in files:
        if file.endswith('.desktop'):
            path = os.path.join(root, file)
            with open(path, 'r') as f:
                content = f.read()
                if 'Name=' not in content:
                    print(f"ERROR: Missing 'Name=' in {path}")
                    errors += 1
                if 'Exec=' not in content:
                    print(f"ERROR: Missing 'Exec=' in {path}")
                    errors += 1
                if 'Type=' not in content:
                    print(f"ERROR: Missing 'Type=' in {path}")
                    errors += 1

if errors == 0:
    print("All checks passed: No duplicates found, and .desktop files are valid.")
else:
    print(f"Validation failed with {errors} errors.")
