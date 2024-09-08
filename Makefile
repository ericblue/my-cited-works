# Makefile to generate README.md

# Define the target to run the shell script
README.md: generate_readme.sh template/template.md data/eric-blue-cited-works.csv
	./generate_readme.sh

# Clean target to remove generated files
clean:
	rm -f README.md
