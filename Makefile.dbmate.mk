# dbmate environment variables.
DBMATE_MIGRATIONS_TABLE := schema_migrations
DBMATE_MIGRATIONS_DIR := ./db/migrations
DBMATE_SCHEMA_FILE := ./db/schema.sql
DATABASE_URL := postgres://$(DB_USER):$(DB_PASS)@$(DB_HOST):$(DB_PORT)/$(DB_NAME)?sslmode=disable

PGPASSWORD := $(DB_PASS)

dbmate := docker run --rm -it \
					--network=host \
					-v "$(PWD)/adapter/postgres/:/db" \
					-e DBMATE_MIGRATIONS_TABLE=$(DBMATE_MIGRATIONS_TABLE) \
					-e DBMATE_MIGRATIONS_DIR=$(DBMATE_MIGRATIONS_DIR) \
					-e DBMATE_SCHEMA_FILE=$(DBMATE_SCHEMA_FILE) \
					-e DATABASE_URL=$(DATABASE_URL) \
					ghcr.io/amacneil/dbmate:2.15.0


conn:
	@echo $(DATABASE_URL)

sql: ## Creates a new migration
	@$(dbmate) new $(name)

sql-help:
	@$(dbmate) -version
	@$(dbmate) -help

migrate: ## Run the migration
	$(dbmate) migrate

rollback: ## Undo the last migration
	@$(dbmate) rollback

reset: ## Drop and apply migrations
	-psql -h $(DB_HOST) -p $(DB_PORT) -U $(DB_USER) -d $(DB_NAME) -w -c "select pg_terminate_backend(pid) from pg_stat_activity where datname = '$(DB_NAME)'";
	@$(dbmate) drop
	@$(dbmate) up
	make seed

seed:
	@psql -h $(DB_HOST) -p $(DB_PORT) -U $(DB_USER) -d $(DB_NAME) -w --single-transaction -f ./adapter/postgres/seed.sql

# Check db size: select pg_size_pretty(pg_database_size('dev'));
