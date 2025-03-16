```makefile
export # This is required

# This allows multiline strings
define template 
1
2
3
boom
endef


# Double dollar sign is required to escape the dollar sign
all:
	@echo "$$template" > output.txt
```


Note the use of $$ANNOUNCE_BODY, indicating a shell environment variable reference, rather than $(ANNOUNCE_BODY), which would be a regular make variable reference. Also be sure to use quotes around your variable reference, to make sure that the newlines aren't interpreted by the shell itself.

```
export ANNOUNCE_BODY
all:
    @echo "$$ANNOUNCE_BODY"
```

## Using variable in template

```makefile
export # This is required

name := "John Doe"

# This allows multiline strings
define template 
1
$(shell echo $(name))
3
boom
endef


# Double dollar sign is required to escape the dollar sign
all:
	@echo "$$template" > output.txt
```
