## Error handling in makefile

In the example below, we use `filter` to check if the `ENV` contains the string `production`. If yes, the string `production` will be returned, and the if will execute:

```mk
define exit_if_production
	$(if $(filter $(1),production), @echo 'cannot run in production' && exit 1, @echo 'safe to execute in $(1)')
endef

run:
	$(call exit_if_production,$(ENV))
	@echo 'running task'
```

## Error guard
We can transform the example above into an error guard:
```mk
define guard_production
	$(if $(filter $(ENV),production),
	@echo 'cannot run in production' && exit 1,
	@echo 'safe to execute')
endef

not_production:
	$(call guard_production)

run: not_production
	@echo 'running task'
```

## Error guard, alternative

```mk

guard_production:
ifeq ($(ENV),production)
	@echo $* cannot run in production && exit 1;
endif

hello: guard_production
	@echo hello
```
