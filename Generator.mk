define pascalcase
	gsed -r 's/(^|-)([a-z])/\U\2/g' <<< $(1)
endef

define camelcase
	gsed -r 's/-([a-z])/\U\1/g' <<< $(1)
endef

define snakecase
	gsed -r 's/-/_/g' <<< $(1)
endef

# There's a catch, we have to use double-dollar $$ to escape the regex match.
# The ! indicates NOT, so the regex below translates to "if the string do not
# match a string that starts with a-z, has only a-z or - (dash) in between and
# ends with a-z, then it is not a kebab-case string and exit the program."
define guard_snakecase
	if [[ ! "$(1)" =~ ^[a-z][a-z-]+[a-z]$$ ]]; \
		then echo 'name must be kebab-case: $(1)' && exit 1; \
	fi
endef

# After calling this function, remember to include the next command in the same
# line, e.g. $(call promp_continue) \ echo 'do sth'
define prompt_continue
	read -p "Continue? [y/N]: " ans && [ $${ans:-N} != y ] && echo "Exiting" && exit 1;
endef

# For the given entity (e.g. user), inject the imports above the given matched pattern.
define template_domain
	# Text pattern to match against.
	$(eval path := src/app/container.ts)
	$(eval pattern := inject containers above)
	$(eval camelCase := `$(call camelcase,$(1))`)
	$(eval pascalCase := `$(call pascalcase,$(1))`)
	for item in Service Repository Resolver; do \
		gsed -i "/$(pattern)/Ii $(camelCase)$$item: asClass($(pascalCase)$$item).singleton()," $(path); \
	done
endef

define template_import
	# Text pattern to match against.
	$(eval pattern := inject imports above)
	$(eval name := `$(call pascalcase,$(1))`)
	$(eval path := src/app/container.ts)
	gsed -i "/$(pattern)/Ii import { $(name)Service, $(name)Repository, $(name)Resolver } from '$(1)'" $(path);
endef

# Remove any line that contains the following import, ignoring case-sensitivity.
define remove_imports
	$(eval path := src/app/container.ts)
	$(eval name := `$(call camelcase,$(1))`)
	for item in Service Repository Resolver; do \
		gsed -i "/$(name)$$item/Id" $(path); \
	done
endef

define replace_line
	$(eval singular := $(shell echo $(1)))
	$(eval pascalCase := `$(call pascalcase,$(1))`)
	$(eval camelCase := `$(call camelcase,$(1))`)
	$(eval snakeCase := `$(call snakecase,$(1))`)
	$(eval folder := src/$(shell echo $(1))/**.ts)
	@read -p "enter plural camelCase name: " pluralCamelCase; \
	read -p "enter plural snake_case name: " pluralSnakeCase; \
	echo "This will perform the following replacements:"; \
	echo "  RelationshipType => $(pascalCase)"; \
	echo "  relationshipType => $(camelCase)"; \
	echo "  relationshipTypes => $$pluralCamelCase"; \
	echo "  relationship_types => $$pluralSnakeCase"; \
	echo "  relationship_type => $(snakeCase)"; \
	echo "  relationship-type => $(singular)"; \
	$(call prompt_continue) \
	cp -R -n src/relationship-type src/$(shell echo $(1)); \
	gsed -i "s/relationshipTypes/$$pluralCamelCase/g" $(folder); \
	gsed -i "s/relationship_types/$$pluralSnakeCase/g" $(folder);
	gsed -i "s/RelationshipType/$(pascalCase)/g" $(folder);
	gsed -i "s/relationshipType/$(camelCase)/g" $(folder);
	gsed -i "s/relationship_type/$(snakeCase)/g" $(folder);
	gsed -i "s/relationship-type/$(singular)/g" $(folder);
endef

remove-service-%:
	@$(call remove_imports,$*)
	@rm -rf src/$*

# The arguments must strictly be kebab-case.
service-%: # Clones the relationship-type folder, and replaces all the name with given name.
	@$(call guard_snakecase,$*)
	$(eval folder := $*)
	@if test -d src/$(folder); then echo "Directory src/$(folder) exists" && exit 1; fi;
	@$(call replace_line,$(folder))
	@echo "Created service at src/$(folder)"
	@echo "Auto-import dependencies in src/app/container.ts";
	@$(call template_import,$*)
	@echo "Auto-initialize dependencies in src/app/container.ts";
	@$(call template_domain,$*)
