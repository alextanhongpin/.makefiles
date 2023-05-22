# Makefile on Steroid with gum


```makefile
# make -v
# GNU Make 4.4.1
# Built for x86_64-apple-darwin21.6.0

# This is lazy, it will only be invoked when calling the command that uses $env.
env=$(shell gum choose "staging" "dev" "prod")
name=$(shell gum input --placeholder "your name")
pass=$(shell gum input --password --placeholder "your password")
desc=$(shell gum write --placeholder "Details of this change (CTRL+D to finish)")
yes_no=$(shell gum confirm "Commit changes?" && echo "DONE")

# What it would look like to get shell input without using gum.
username=$(shell read -p 'Username: ' usr; echo $$usr)
password=$(shell read -s -p 'Password: ' pwd; echo $$pwd) # -s for silent


install:
	@go install github.com/charmbracelet/gum@latest
	@go install github.com/charmbracelet/vhs@latest
	@go install github.com/charmbracelet/glow@latest



# Multi-line script
migrate2:
	@export e=$(env); \
	export n=$(name); \
	export p=$(pass); \
	echo env: $${e} user: $${u} pass: $${p}


.ONESHELL: # Or enable this.
migrate:
	@export val=$(env) # For this to work, specify ONESHELL, so that all lines in a command is run under one shell
										 # However, this applies to all other commands.
										 # This also only works with Makefile 3.8.2 and above.
	@echo Env: $${val} # Must be double dollar, and curly brackets, not round brackets.
	@echo Name: $(name)
	@echo Pass: $(pass)


login:
	@echo "Username > $(username)"
	@echo "Password > $(password)"


commit:
	@echo $(desc)
	@echo $(yes_no)


choice:
	echo "Do you wish to install this program?"
	$(CHOICE)


zx:
	./node_modules/.bin/zx index.mjs
```

## Exporting environment in one line to be used in another line


By default, every line in the command runs in a new shell. The environment defined in one shell is not visible in another. So the options we have is to either

1) run them in the same line
2) use `.ONESHELL:` to make all commands run in a single shell

Using new line and `$${varname}`:
```makefile
# Multi-line script
migrate2:
	@export e=$(env); \
	export n=$(name); \
	export p=$(pass); \
	echo env: $${e} user: $${u} pass: $${p}
```

Using `.ONESHELL:`:
```makefile
.ONESHELL: # Or enable this.
migrate:
	@export val=$(env) # For this to work, specify ONESHELL, so that all lines in a command is run under one shell
										 # However, this applies to all other commands.
										 # This also only works with Makefile 3.8.2 and above.
	@echo Env: $${val} # Must be double dollar, and curly brackets, not round brackets.
	@echo Name: $(name)
	@echo Pass: $(pass)
```
