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
