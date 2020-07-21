## Exploring conditionals

The `if` behaves differently - it does not expect `true` or `false`, instead it expects `non-empty` (equals true) or `empty` (equals false).

To mimic the `if-else`, we use `filter-out` to represent `not_equal`, and `filter` to represent `equal`. Note that after filtering, the values on the right will no longer contain the filtered items.
```Makefile
test:
	@echo 'will return two:' $(filter-out "one", "two")
	@echo 'will return empty:' $(filter-out "one", "one")
	@echo 'will return empty:' $(filter "one", "two")
	@echo 'will return one:' $(filter "one",  "one")
	$(if $(filter-out 'first', 'first'), echo "this is empty", echo "this is not empty")
```

## Conditional


```Makefile
define check_equal
	echo $(if $(filter $(1), $(2)), "yes", "no")
endef

define check_not_equal
	echo $(if $(filter-out $(1), $(2)), "yes", "no")
endef

define do_work
	# Makefile does not escape comma...
	$(eval comma := ,)
	$(eval input := $(1))
	#echo provided input is: $(input)
	#echo after filtering: $(filter-out "42", $(input))
	$(eval answer := $(if $(filter-out "42", $(input)), echo "wrong answer: got $(input)$(comma) expected 42" && exit 1, $(input))
)
	echo $(answer)
endef

test:
	@$(call check_equal,"foo", "bar")
	@$(call check_equal,"foo", "foo")

	@$(call check_not_equal,"foo", "bar")
	@$(call check_not_equal,"foo", "foo")

	@$(call do_work,"42")
	@$(call do_work,"41")
```
