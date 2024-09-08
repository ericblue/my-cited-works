# Makefile to generate README.md

# Define the target
README.md: template/template.md data/eric-blue-cited-works.csv
	# Convert CSV to Markdown table
	pandoc -f csv -t markdown_strict data/eric-blue-cited-works.csv -o table.md

	# Initialize the temp_readme.md with the content of the template
	cp template/template.md temp_readme.md

	# Loop through each markdown file in the include directory
	for file in include/*.md; do \
		placeholder="<!-- $$(basename $$file .md | tr '[:lower:]' '[:upper:]') -->"; \
		sed "/$$placeholder/r $$file" temp_readme.md > temp_readme2.md && mv temp_readme2.md temp_readme.md; \
	done

	# Replace the CSV table placeholder
	sed '/<!-- CITED_WORKS_TABLE -->/r table.md' temp_readme.md > temp_readme2.md && mv temp_readme2.md temp_readme.md

	# Insert the current date in YYYY-MM-DD format
	CURRENT_DATE=$(shell date +%Y-%m-%d); \
	sed "s|<!-- CURRENT_DATE -->|$$CURRENT_DATE|" temp_readme.md > temp_readme2.md && mv temp_readme2.md temp_readme.md

	# Remove HTML comments from the generated README.md
	# Remove any HTML comment tags from the generated README.md
	sed -e 's/<!--.*-->//g' temp_readme.md > README.md

	#cp temp_readme.md README.md

	# Clean up temporary files
	rm temp_readme.md table.md

# Clean target to remove generated files
clean:
	rm -f README.md temp_readme.md temp_readme2.md table.md
