SHELL := /bin/bash

.PHONY: dev-up dev-down dev-status local-up local-init local-unseal local-login local-down local-status clean

dev-up:
	./scripts/dev-up.sh

dev-down:
	./scripts/dev-down.sh

dev-status:
	./scripts/dev-status.sh

local-up:
	./scripts/local-up.sh

local-init:
	./scripts/local-init.sh

local-unseal:
	./scripts/local-unseal.sh

local-login:
	./scripts/local-login.sh

local-down:
	./scripts/local-down.sh

local-status:
	./scripts/local-status.sh

clean:
	rm -rf .runtime .local .vault-token

