APP_NAME=rails-api-starter

# Compose override defaults (can be overridden via command line)
ENV_FILE?=.env.dev
COMPOSE_FILE?=docker-compose.dev.yml
DOCKER_COMPOSE=docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE)

# Common commands
up:
	$(DOCKER_COMPOSE) up

down:
	$(DOCKER_COMPOSE) down

build:
	$(DOCKER_COMPOSE) build

restart: down build up

logs:
	$(DOCKER_COMPOSE) logs -f app

sh:
	$(DOCKER_COMPOSE) exec app bash

psql:
	$(DOCKER_COMPOSE) exec db psql -U $$POSTGRES_USER

# Rails tasks
migrate:
	$(DOCKER_COMPOSE) run --rm app bin/rails db:migrate

seed:
	$(DOCKER_COMPOSE) run --rm app bin/rails db:seed

setup:
	$(DOCKER_COMPOSE) run --rm app bin/rails db:setup

reset:
	$(DOCKER_COMPOSE) run --rm app bin/rails db:reset

# RSpec
rspec:
	$(DOCKER_COMPOSE) run --rm app bundle exec rspec

# Aliases
dev:
	$(MAKE) up ENV_FILE=.env.dev COMPOSE_FILE=docker-compose.dev.yml

test:
	$(MAKE) up ENV_FILE=.env.test COMPOSE_FILE=docker-compose.test.yml

prod:
	$(MAKE) up ENV_FILE=.env.prod COMPOSE_FILE=docker-compose.prod.yml

ci:
	$(MAKE) rspec ENV_FILE=.env.test COMPOSE_FILE=docker-compose.test.yml

# Linting
lint:
	$(DOCKER_COMPOSE) run --rm app bundle exec rubocop

# Deploy to production via SSH
deploy:
	ssh user@your-server-ip "cd /path/to/$(APP_NAME) && git pull && docker compose -f docker-compose.prod.yml --env-file .env.prod up --build -d"

lint-fix:
	$(DOCKER_COMPOSE) run --rm app bundle exec rubocop -A

test-coverage:
	$(DOCKER_COMPOSE) run --rm app bundle exec rspec --format RspecJunitFormatter --out tmp/rspec.xml

db-create:
	$(DOCKER_COMPOSE) run --rm app bin/rails db:create

# TODO:
# Replace:

# 	•	user@your-server-ip — replace with your SSH user and IP
# 	•	/path/to/rails-api-starter — to the path of the project on the server

# It is also recommended that the SSH key is already configured for access.