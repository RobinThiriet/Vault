# Vault Local Lab

Environnement local de demonstration pour apprendre HashiCorp Vault avec Docker Compose, une documentation structuree et des ateliers pratiques.

## Pourquoi ce repo

Ce projet sert de base de travail pour:

- lancer Vault rapidement sur un poste local
- comprendre le cycle d'administration `init`, `unseal` et `login`
- pratiquer sur un environnement reproductible
- partager une base propre et documentee avec d'autres personnes

## Perimetre

Ce repo est pense pour l'apprentissage et la demonstration locale.

Il ne cherche pas a reproduire une architecture de production. Il privilegie:

- la simplicite de lancement
- la lisibilite
- la reproductibilite

## Prerequis

- Docker
- Docker Compose
- acces a ce depot Git

## Stack

- image Vault: `hashicorp/vault:1.21.4`
- orchestration: Docker Compose
- configuration: HCL versionnee dans le repo
- persistance: `vault-data/`
- secrets de bootstrap locaux: `.local/`
- UI/API locale: `http://127.0.0.1:8200`

## Demarrage rapide

```bash
make up
make init
make unseal
make login
make status
```

Pour arreter le lab:

```bash
make down
```

## Documentation

- [docs/architecture.md](/root/Vault/docs/architecture.md)
- [docs/operations.md](/root/Vault/docs/operations.md)

## Architecture

Vue simplifiee:

```text
Utilisateur
  -> Makefile
  -> scripts/
  -> Docker Compose
  -> conteneur Vault
  -> stockage local vault-data/
  -> cles locales .local/
```

Pour le schema detaille et l'explication composant par composant:

- [docs/architecture.md](/root/Vault/docs/architecture.md)

## Commandes principales

- `make up` demarre Vault
- `make init` initialise Vault
- `make unseal` descelle Vault
- `make login` connecte la CLI avec le token root
- `make status` affiche l'etat du serveur
- `make logs` affiche les logs du conteneur
- `make shell` ouvre un shell dans le conteneur
- `make down` arrete le lab
- `make clean` supprime les donnees locales du lab

Le detail operational est documente ici:

- [docs/operations.md](/root/Vault/docs/operations.md)

## Ateliers guides

Premier atelier disponible:

- [workshops/01-kv-policy-token.md](/root/Vault/workshops/01-kv-policy-token.md)

Policy d'exemple associee:

- [policies/dev-read-demo.hcl](/root/Vault/policies/dev-read-demo.hcl)

## Structure du repo

```text
docker-compose.yml       Stack Docker Compose
config/docker/vault.hcl  Configuration Vault
docs/*.md                Documentation d'architecture et d'exploitation
policies/*.hcl           Policies d'exemple
scripts/*.sh             Scripts utilitaires
workshops/*.md           Ateliers guides
Makefile                 Raccourcis de lancement
```

## Donnees locales

Ces repertoires sont exclus de Git:

- `.local/`
- `vault-data/`

Ils contiennent respectivement:

- les cles et tokens de bootstrap locaux
- les donnees persistantes du serveur Vault

## Limites connues

Ce lab est volontairement non production:

- pas de TLS
- un seul noeud
- backend `file`
- root token conserve localement pour l'apprentissage

## Roadmap

Pistes d'amelioration du repo:

1. ajouter un atelier AppRole
2. ajouter un atelier Transit
3. ajouter un atelier PKI
4. ajouter un mode TLS local
5. ajouter un audit device
