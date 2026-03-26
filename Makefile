SHELL=/bin/bash
.PHONY: *

list:
	@LC_ALL=C $(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

install: # Developer mode installation
	bash ./docker.sh install-dev

up:
	docker compose up -d --remove-orphans

down:
	docker compose down

restart: down up

web-up:
	docker compose up -d azuracast --remove-orphans

build: # Rebuild all containers and restart
	docker compose build
	$(MAKE) restart

post-update:
	$(MAKE) down
	docker compose run --rm web azuracast_dev_install --update
	$(MAKE) up

update: # Update everything (i.e. after a branch update)
	docker compose build
	$(MAKE) post-update

build-depot: # Rebuild all containers with Depot and restart
	depot bake -f docker-compose.yml -f docker-compose.override.yml --load
	$(MAKE) restart

update-depot: # Update everything using Depot
	depot bake -f docker-compose.yml -f docker-compose.override.yml --load
	$(MAKE) post-update

test:
	docker compose exec --user=azuracast web composer run cleanup-and-test

bash:
	docker compose exec --user=azuracast web bash

bash-root:
	docker compose exec web bash

generate-locales:
	docker compose exec --user=azuracast web azuracast_cli locale:generate

import-locales:
	docker compose exec --user=azuracast web azuracast_cli locale:import

openssl:
	@echo "$(YELLOW)ℹ️  Creating openssl password...$(NC)"
	@openssl rand -base64 32 | tr -d '=+/ ' | cut -c1-20
	@echo "$(GREEN)✅  Openssl password created above..$(NC)"

up-dbs:
	@echo "$(YELLOW)ℹ️  Starting KeyDB and MariaDB...$(NC)"
	@docker compose up -d keydb mariadb
	@echo "$(GREEN)✅  KeyDB and MariaDB started...$(NC)"

up-sftpgo:
	@echo "$(YELLOW)ℹ️  Starting SFTPGo...$(NC)"
	@docker compose up -d sftpgo
	@echo "$(GREEN)✅  SFTPGo started...$(NC)"

up-centrifugo:
	@echo "$(YELLOW)ℹ️  Starting Centrifugo...$(NC)"
	@docker compose up -d centrifugo
	@echo "$(GREEN)✅  Centrifugo started...$(NC)"

up-web:
	@echo "$(YELLOW)ℹ️  Starting web...$(NC)"
	@docker compose up -d web
	@echo "$(GREEN)✅   Web started...$(NC)"

up-minimal:
	@echo "$(YELLOW)ℹ️  Starting minimal services...$(NC)"
	@docker compose up -d keydb mariadb sftpgo centrifugo web
	@echo "$(GREEN)✅  Minimal services started...$(NC)"
