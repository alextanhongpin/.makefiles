# node.js setup with db-migrate modules.

sql-%:
	@npm run db-migrate create $*

migrate:
	@npm run db-migrate up

rollback:
	@npm run db-migrate down

reset:
	@npm run db-migrate reset

seed-%:
	@npm run db-migrate create:seed $*

migrate-seed:
	@npm run db-migrate up:seed

rollback-seed:
	@npm run db-migrate down:seed

reset-seed:
	@npm run db-migrate reset:seed
