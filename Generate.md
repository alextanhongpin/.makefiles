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

# Multi-line function
define test_multi
	$(eval first := $(1))
	$(eval second := $(2))
	echo "$$first $$second"
endef

test:
	@$(call test_multi,"first","second")
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

## Add imports / remove imports using SED

```mk
# For the given entity (e.g. user), inject the imports above the given matched pattern.
define template_inject
	# Text pattern to match against.
	$(eval pattern := inject code here)
	$(eval name := $(shell echo $(1)))
	for item in Service Repository; do \
		gsed -i "/$(pattern)/Ii $(name)$$item: container($(name)$$item).asClass()" text.txt; \
	done
endef

define template_import
	# Text pattern to match against.
	$(eval pattern := inject code here)
	$(eval name := $(shell echo $(1)))
	gsed -i "/$(pattern)/Ii import { $(name)Service, $(name)Repository, $(name)Resolver } from '$(name)'" text.txt;
endef

# Remove any line that contains the following import, ignoring case-sensitivity.
define remove_line
	gsed -i "/$(shell echo $(1))Service/Id" text.txt; \
	gsed -i "/$(shell echo $(1))Repository/Id" text.txt
endef

inject:
	$(call template_import,'user')
	$(call template_inject,'user')

remove_import:
	$(call remove_line,'user')
```
