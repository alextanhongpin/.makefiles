# Example code generation with makefile

The command expects a `kebab-case` package name,
and it will perform the following:

1. check if destination folder exists (exit if yes)
2. perform case conversion (`kebab-case` to `PascalCase` and `camelCase`
3. display converted values
4. prompt user for confirmation (exit if the answer provided is not equal `y`
5. copies the folder and perform rename with `sed`

```
# The arguments must strictly be kebab-case, since the camelCase and pascalCase only converts from kebab-case.
service-%: # Clones the currency folder, and replaces all the name with given name.
	@folder=$*; \
	PascalCase=$(shell echo $* | gsed -r 's/(^|-)([a-z])/\U\2/g'); \
	camelCase=$(shell echo $* | gsed -r 's/-([a-z])/\U\1/g'); \
	if test -d src/$$folder; then echo "Directory src/$$folder exists" && exit 1; fi; \
	read -p "Enter pluralize name: " plural; \
	echo "Create a service at $$folder"; \
	echo "This will perform the following replacements:"; \
	echo "  Currency => $$PascalCase"; \
	echo "  currency => $$camelCase"; \
	echo "  currencies => $$plural"; \
	read -p "Continue? [y/N]: " ans && [ $${ans:-N} != y ] && echo "Exiting" && exit 1; \
	cp -R -n src/currency src/$$folder ; \
	sed -i "" "s/Currency/$$PascalCase/g" src/$$folder/**.ts; \
	sed -i "" "s/currency/$$camelCase/g" src/$$folder/**.ts; \
	sed -i "" "s/currencies/$$plural/g" src/$$folder/**.ts; \
	echo "Created $$folder";
```

## Using reusable functions.

```Makefile
define pascalcase
	gsed -r 's/(^|-)([a-z])/\U\2/g' <<< $(1)
endef

define camelcase
	gsed -r 's/-([a-z])/\U\1/g' <<< $(1)
endef

test:
	@$(call pascalcase,'hello-world')
	@$(call camelcase,'hello-world')
```

Note that the argument must be in backticks:
```Makefile
# The arguments must strictly be kebab-case.
service-%: # Clones the currency folder, and replaces all the name with given name.
	@folder=$*; \
	PascalCase=`$(call pascalcase, $*)`; \
	camelCase=`$(call camelcase, $*)`; \
	if test -d src/$$folder; then echo "Directory src/$$folder exists" && exit 1; fi; \
	read -p "Enter pluralize name: " plural; \
	echo "Create a service at $$folder"; \
	echo "This will perform the following replacements:"; \
	echo "  Currency => $$PascalCase"; \
	echo "  currency => $$camelCase"; \
	echo "  currencies => $$plural"; \
	read -p "Continue? [y/N]: " ans && [ $${ans:-N} != y ] && echo "Exiting" && exit 1; \
	cp -R -n src/currency src/$$folder ; \
	sed -i "" "s/Currency/$$PascalCase/g" src/$$folder/**.ts; \
	sed -i "" "s/currency/$$camelCase/g" src/$$folder/**.ts; \
	sed -i "" "s/currencies/$$plural/g" src/$$folder/**.ts; \
	echo "Created $$folder";
```
