#!/bin/bash

# Read the template content into a variable
OUTPUT=$(cat template/template.md)

# Function to replace placeholders with either file content or inline content
insert_content() {
    local placeholder="<!-- $1 -->"
    local content="$2"

    if [ -f "$content" ]; then
        # Insert file content
        OUTPUT=$(echo "$OUTPUT" | sed -e "/$placeholder/r $content" -e "/$placeholder/d")
    else
        # Replace placeholder with inline content
        OUTPUT=$(echo "$OUTPUT" | sed "s|$placeholder|$content|g")
    fi
}

# Loop through each markdown file in the include directory and insert content
echo "Inserting content from markdown files in the include directory ..."
for file in include/*.md; do
    placeholder="$(basename "$file" .md | tr '[:lower:]' '[:upper:]')"
    insert_content "$placeholder" "$file"
done

# Convert CSV to Markdown table and store it in a temporary file
pandoc -f csv -t markdown_strict data/eric-blue-cited-works.csv -o table.tmp

# Insert the table content using the temporary file
echo "Inserting content from cited works CSV file as a Markdown table ..."
insert_content "CITED_WORKS_TABLE" "table.tmp"

# Insert the current date in YYYY-MM-DD format
CURRENT_DATE=$(date +%Y-%m-%d)
insert_content "CURRENT_DATE" "$CURRENT_DATE"

# Remove HTML comments and write the final output to README.md
echo "Writing the final output to README.md ..."
echo "$OUTPUT" | sed -e 's/<!--.*-->//g' > README.md

# Clean up the temporary table file
rm table.tmp

ls -l README.md
