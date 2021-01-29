# Setting default values

```mk
echo:
	@echo $(or ${hello},world)
	@echo $${hello:=world}
```

Output:
```
$ make echo // world
$ make echo hello=hi // hi
```

Alternative:
```mk
hello ?= world
echo:
	@echo $(hello)
```
