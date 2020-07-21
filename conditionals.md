## Exploring conditionals

```Makefile
test:
	@echo 'will return two:' $(filter-out "one", "two")
	@echo 'will return empty:' $(filter-out "one", "one")
	@echo 'will return empty:' $(filter "one", "two")
	@echo 'will return one:' $(filter "one",  "one")
	$(if $(filter-out 'first', 'first'), echo "this is empty", echo "this is not empty")
```
