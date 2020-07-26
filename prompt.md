## Function to prompt to continue

```mk
define prompt_continue
	@read -p "Continue? [y/N]: " ans && [ $${ans:-N} != y ] && echo "Exiting" && exit 1;
endef


# Note the newline, when we use read -p, we have to chain the command.
do_work:
	$(call prompt_continue) \
	echo 'yess'
```
