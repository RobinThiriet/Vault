SHELL := /bin/bash

.PHONY: up down logs status init unseal login shell clean

up:
	./scripts/up.sh

down:
	./scripts/down.sh

logs:
	docker compose logs -f vault

status:
	./scripts/status.sh

init:
	./scripts/init.sh

unseal:
	./scripts/unseal.sh

login:
	./scripts/login.sh

shell:
	docker compose exec vault sh

clean:
	rm -rf .local .vault-token vault-data
