
# This script will be executed after commit in placed in .git/hooks/post-commit

# Semantic Versioning 2.0.0 guideline
#
# Given a version number MAJOR.MINOR.PATCH, increment the:
# MAJOR version when you make incompatible API changes,
# MINOR version when you add functionality in a backwards-compatible manner, and
# PATCH version when you make backwards-compatible bug fixes.
# Reset
Color_Off=\033[0m
Cyan=\033[0;36m
Green=\033[0;32m

VERSION:=$(shell git describe --tags --abbrev=0)

MAJOR=$(shell echo ${VERSION} | cut -d'.' -f1)
MINOR=$(shell echo ${VERSION} | cut -d'.' -f2)
PATCH=$(shell echo ${VERSION} | cut -d'.' -f3)

# Returns the string 'v' if exists, or empty if otherwise.
PREFIX=$(findstring v,$(VERSION))

major:
	$(eval MAJOR=$(shell echo $$(($(MAJOR)+1))))
	@echo
	@echo "Next $(Green)MAJOR$(Color_Off) version: $(VERSION) ~> $(PREFIX)$(Green)$(MAJOR)$(Color_Off).$(MINOR).$(PATCH)"
	@echo "Run $(Cyan)make bump-major$(Color_Off) to bump the version."
	@echo

minor:
	@# This is required to get rid of the version prefix 'v'.
	$(eval MAJOR=$(shell echo $$(($(MAJOR)+0))))
	$(eval MINOR=$(shell echo $$(($(MINOR)+1))))
	@echo
	@echo "Next $(Green)MINOR$(Color_Off) version: $(VERSION) ~> $(PREFIX)$(MAJOR).$(Green)$(MINOR)$(Color_Off).$(PATCH)"
	@echo "Run $(Cyan)make bump-minor$(Color_Off) to bump the version."
	@echo

patch:
	@# This is required to get rid of the version prefix 'v'.
	$(eval MAJOR=$(shell echo $$(($(MAJOR)+0))))
	$(eval PATCH=$(shell echo $$(($(PATCH)+1))))
	@echo
	@echo "Next $(Green)PATCH$(Color_Off) version: $(VERSION) ~> $(PREFIX)$(MAJOR).$(MINOR).$(Green)$(PATCH)$(Color_Off)"
	@echo "Run $(Cyan)make bump-patch$(Color_Off) to bump the version."
	@echo

bump-major:
	$(eval MAJOR=$(shell echo $$(($(MAJOR)+1))))
	@echo
	@echo "Bumping $(Green)MAJOR$(Color_Off) version: $(VERSION) ~> $(PREFIX)$(Green)$(MAJOR)$(Color_Off).$(MINOR).$(PATCH)"
	$(eval NEXT_VERSION=$(PREFIX)$(MAJOR).$(MINOR).$(PATCH))
	git tag -a $(NEXT_VERSION) -m "Release $(NEXT_VERSION)"
	git push origin --tags


bump-minor:
	$(eval MAJOR=$(shell echo $$(($(MAJOR)+0))))
	$(eval MINOR=$(shell echo $$(($(MINOR)+1))))
	@echo
	@echo "Bumping $(Green)MINOR$(Color_Off) version: $(VERSION) ~> $(PREFIX)$(MAJOR).$(Green)$(MINOR)$(Color_Off).$(PATCH)"
	$(eval NEXT_VERSION=$(PREFIX)$(MAJOR).$(MINOR).$(PATCH))
	git tag -a $(NEXT_VERSION) -m "Release $(NEXT_VERSION)"
	git push origin --tags

bump-patch:
	$(eval MAJOR=$(shell echo $$(($(MAJOR)+0))))
	$(eval PATCH=$(shell echo $$(($(PATCH)+1))))
	@echo
	@echo "Bumping $(Green)PATCH$(Color_Off) version: $(VERSION) ~> $(PREFIX)$(MAJOR).$(MINOR).$(Green)$(PATCH)$(Color_Off)"
	$(eval NEXT_VERSION=$(PREFIX)$(MAJOR).$(MINOR).$(PATCH))
	git tag -a $(NEXT_VERSION) -m "Release $(NEXT_VERSION)"
	git push origin --tags
