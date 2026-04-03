# Vault Local Lab

Base de travail Docker Compose pour lancer HashiCorp Vault en local, s'entrainer dessus, et partager un environnement reproductible.

## Objectifs

- demarrer Vault sans installation locale du binaire
- apprendre le cycle `up -> init -> unseal -> login`
- garder un repo simple a lancer pour d'autres personnes

## Prerequis

- Docker
- Docker Compose
- acces a ce depot Git

## Stack choisie

- image: `hashicorp/vault:1.21.4`
- mode: conteneur local persistant
- UI/API: `http://127.0.0.1:8200`
- stockage local: `vault-data/`

## Demarrage rapide

```bash
make up
make init
make unseal
make login
make status
```

Arret:

```bash
make down
```

Logs:

```bash
make logs
```

Shell dans le conteneur:

```bash
make shell
```

## Ce que fait chaque commande

### `make up`

Demarre Vault avec Docker Compose.

### `make init`

Initialise Vault et enregistre les secrets de bootstrap dans `.local/keys/init.txt`.

### `make unseal`

Utilise la cle d'initialisation stockee localement pour desceler Vault.

### `make login`

Utilise le root token stocke localement pour authentifier la CLI dans le conteneur.

### `make status`

Affiche l'etat courant de Vault.

## Stockage local

Ces repertoires sont exclus de Git:

- `.local/`
- `vault-data/`

Ils contiennent respectivement:

- les cles et token d'initialisation locaux
- les donnees persistantes du conteneur Vault

## Premier parcours d'apprentissage

Une fois `make login` execute:

```bash
docker compose exec vault sh
export VAULT_ADDR=http://127.0.0.1:8200
vault secrets enable -path=secret kv-v2
vault kv put secret/demo username=robin password=test123
vault kv get secret/demo
```

## Ateliers guides

Le repo contient maintenant un premier atelier pas a pas:

- [workshops/01-kv-policy-token.md](/root/Vault/workshops/01-kv-policy-token.md)

Fichier de policy associe:

- [policies/dev-read-demo.hcl](/root/Vault/policies/dev-read-demo.hcl)

## Structure du repo

```text
docker-compose.yml       Stack Docker Compose
config/docker/vault.hcl  Configuration Vault
policies/*.hcl           Policies d'exemple
scripts/*.sh             Scripts utilitaires
workshops/*.md           Ateliers guides
Makefile                 Raccourcis de lancement
```

## Notes utiles

- cette version privilegie Docker Compose pour etre plus simple a partager
- aucune installation systeme de `vault` n'est necessaire
- l'historique Git conserve la trace du passage natif vers Docker

## Suite logique

Une bonne suite pour enrichir ce repo:

1. ajouter des exercices guides
2. ajouter des policies d'exemple
3. ajouter AppRole, Transit et PKI
4. ajouter un reset complet du lab Docker
