# You can generate templates using environment variables.
include .env
export

NAME := world

# template.txt
# hello ${NAME}

# About envsubst: https://www.gnu.org/software/gettext/manual/html_node/envsubst-Invocation.html
# TL;DR; The envsubst program substitutes the values of environment variables.

echo:
	@# Read from template.txt, and write to out.txt
	@echo envsubst < template.txt > out.txt
	@echo wrote to out.txt

dry-run:
	@envsubst < template.txt
