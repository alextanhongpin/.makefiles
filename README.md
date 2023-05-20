# .makefiles
Automate everything with Makefile 

# Makefile basics

- [Creating a Makefile](#creating-a-makefile)
- [Hello World](#hello-world)
- [Chaining Commands](#chaining-commands)
- [Suppressing command output](#suppressing-command-output)
- [Using environment variables](#using-environment-variables)
- [Loading environment variables from file](#loading-environment-variables-from-file)
- [Loading enviroment variables dynamically](#loading-enviroment-variables-dynamically)
- [Environment guards](#environment-guards)
- [You can make a CLI with your Makefile](#you-can-make-a-cli-with-your-makefile)
- [Useful variables](#useful-variables)
- [Using dynamic variables in command](#using-dynamic-variables-in-command)
- [Modular Makefiles](#modular-makefiles)
- [Read Input](#read-input)

## Creating a Makefile

```bash
$ touch Makefile
```

## Hello World

In your `Makefile`:
```Makefile
greet:
	echo hello world
```

```bash
$ make greet
> hello world
```

## Chaining Commands

You can chain commands in `Makefile`:

```Makefile
greet: bid
	echo hello

bid:
	echo bye
```

This is especially useful when you have multiple steps involved, e.g. building and deploying a container:

```Makefile
deploy: build tag push
	echo deploying

build:
	echo building image

tag:
	echo tagging the image

push: 
	echo pushing to dockerhub
```

## Suppressing command output

To suppress the command being executed, add `@` before the command:

```Makefile
greet:
	@echo hello
```

## Using environment variables

You can pass environment variables into `Makefile` when running the command:

```Makefile
greet:
	@echo Hi, $(NAME)!
```

Running the `greet` command:
```bash
$ NAME=john make greet
> Hi, john!
```

This is useful if you need to use Makefile to configure builds for certain environment, e.g. `ENV=prod make build`.

## Loading environment variables from file

Makefile can also load environment variables from `.env` file

```Makefile
include .env
export
```

If you want to make it optional, add the minus sign before include. Otherwise, an error will occur:

```Makefile
-include .env
export
```

The `export` will export all available environment variables in the `Makefile`. 

> You can include as many `.env` files as you want, the order matters though:

```Makefile
.env.development
.env # This will overwrite any values that already existed in .env.development
export
```

## Loading enviroment variables dynamically

You can also load environment variables dynamically:

```Makefile
ENV ?= development    # Defaults to development.
-include .env         # Include the base environment.
-include .env.$(ENV)  # Will load based on your current environment, and overrides the values in base environment file.
export

greet:
    echo Running in $(ENV)
```

Run:
```bash
$ make greet ENV=development
> Running in development

$ make greet ENV=production
> Running in production
```

## Environment guards

Say if we only want to ensure that certain command can only be run in certain environment:

```Makefile
ENV ?= development
-include .env
-include .env.$(ENV)
export

deploy: prod-only
	@echo deploying to production

prod-only:
ifneq ($(ENV),production)
	$(error ENV must be production)
endif
```

Run:
```bash
$ make deploy
> Makefile:6: *** ENV must be production.  Stop.

$ make deploy ENV=production
> deploying to production
```

## You can make a CLI with your Makefile

```Makefile
.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

vendor: ## Vendor the application
	@echo vendoring...
```

Just run `make` without any commands, it will print the command and the description.

## Useful variables

```Makefile
PROJECTNAME := $(shell basename $(PWD))
COMMIT=$(shell git rev-parse HEAD)
BRANCH=$(shell git rev-parse --abbrev-ref HEAD)
BUILD_DATE := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
CURRENT_DIR=$(shell pwd)
VERSION := $(shell git describe --tags --abbrev=0)

COLOR="\033[32;1m"
ENDCOLOR="\033[0m"
```

## Using dynamic variables in command

```Makefile
# To override just a single environment variable inline.
deploy:
	@echo ${A}

# make deploy-staging
# make deploy-production
deploy-%: .env.%
	@$(MAKE) deploy ENV=$*
```

## Modular Makefiles

You can separate your Makefiles into smaller Makefiles. This promote reusability, while keeping your Makefile small. Say you have the following Makefiles:

In `database/Makefile`:

```Makefile
start:
	@echo starting db
  
stop:
	@echo stopping db
```
In `docker/Makefile`:

```Makefile
IMG := alextanhongpin/api
build:
  @docker build -t $(IMG) .
  
up:
  @docker-compose up -d
  
down:
  @docker-compose down
```

You can now include them in your main `Makefile` at the root of your project directory:

```Makefile
include docker/Makefile
include database/Makefile

greet:
	echo greet
```

And you can run all the commands that are available in `docker/Makefile` and `database/Makefile`:

```bash
$ make up
$ make down
$ make start
$ make stop
```

The only disadvantage is that the naming of the command cannot be the same.

## Read Input

You can read input in makefiles too. The example below copies an existing folder and rename all the variables/classes for code reuse:

```makefile
service: # Clones the currency folder, and replaces all the name with given name.
	@read -p "Enter folder name: " folder; \
	read -p "Enter class name: " class; \
	read -p "Enter singular name: " singular; \
	read -p "Enter pluralize name: " plural; \
	cp -r src/currency src/$$folder; \
	sed -i "" "s/Currency/$$class/g" src/$$folder/**.ts; \
	sed -i "" "s/currency/$$singular/g" src/$$folder/**.ts; \
	sed -i "" "s/currencies/$$plural/g" src/$$folder/**.ts;
```


## Makefile alternatives

- https://taskfile.dev/
- https://github.com/casey/just (this is particularly interesting, however, it requires installation while Makefile doesn't)
- https://magefile.org/
