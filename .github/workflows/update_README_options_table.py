import re
import string

readmePath = "../../README.md"

def insertTable(new_options_table):
    # Load the Markdown file
    with open("file.md", "r", encoding="utf-8") as f:
        content = f.read()
    
    # Regular expression to find the table under "# Options"
    options_table_pattern = r"# Options\n(\n|[^|])*(?P<Table>(\|.+\n)*).*"
    
    def replace_table(match):
        # Get the original match
        original = match.group(0)
        # Get the table part
        table = match.group('Table')
        # Replace just the table part
        return original.replace(table, new_options_table)
    
    # Replace only the table while keeping all surrounding text intact
    updated_content = re.sub(options_table_pattern, replace_table, content)
    
    # Save the updated file
    with open("file.md", "w", encoding="utf-8") as f:
        f.write(updated_content)

f = open("default.nix", "r")
content = f.read()
regex = r"options\.(?P<name>\S+) = \S+ {\n\s+type = [^types]*types.(?P<type>[^;]+);\n\s+description = \"(?P<description>[^\"]+)\";\n\s+default = (?P<default>[^;]+)"
x = re.finditer(regex , content)

lst = []
lst.append("""| Option name | Type | Description | Default value |
|---------|---------|---------|---------|\n""")

for match in x:
    option = match.groupdict()
    row = f"|{option["name"]}|{option["type"]}|{option["description"]}|{option["default"]}|\n"
    lst.append(row)
table = "".join(lst)
insertTable(table)

