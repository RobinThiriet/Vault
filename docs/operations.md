# Operations Guide

Ce document centralise les commandes utiles, le cycle de vie du lab et les procedures de depannage.

## Commandes principales

### Demarrer le lab

```bash
make up
```

### Initialiser Vault

```bash
make init
```

### Desceller Vault

```bash
make unseal
```

### Se connecter avec le token root

```bash
make login
```

### Verifier l'etat du serveur

```bash
make status
```

### Voir les logs

```bash
make logs
```

### Ouvrir un shell dans le conteneur

```bash
make shell
```

### Arreter le lab

```bash
make down
```

### Nettoyer les donnees locales

```bash
make clean
```

Attention:

- `make clean` supprime les donnees persistantes locales
- il faudra reinitialiser Vault ensuite

## Cycle de vie normal

### Premier lancement

```bash
make up
make init
make unseal
make login
make status
```

### Redemarrage apres un arret

```bash
make up
make unseal
make login
make status
```

`make init` n'est a executer qu'une seule fois tant que `vault-data/` n'est pas supprime.

## Fichiers importants

- [docker-compose.yml](/root/Vault/docker-compose.yml)
- [config/docker/vault.hcl](/root/Vault/config/docker/vault.hcl)
- [Makefile](/root/Vault/Makefile)
- [scripts/up.sh](/root/Vault/scripts/up.sh)
- [scripts/init.sh](/root/Vault/scripts/init.sh)
- [scripts/unseal.sh](/root/Vault/scripts/unseal.sh)
- [scripts/login.sh](/root/Vault/scripts/login.sh)

## Depannage

### Le conteneur ne demarre pas

Verifier l'etat du service:

```bash
docker compose ps
docker compose logs vault
```

Verifier qu'aucun autre service n'utilise les ports `8200` ou `8201`.

### `make status` indique que Vault est scelle

C'est normal apres un redemarrage. Il faut relancer:

```bash
make unseal
```

### `make init` indique que Vault est deja initialise

C'est normal si `vault-data/` contient deja un etat Vault existant. Dans ce cas:

- ne pas reinitialiser
- utiliser `make unseal`
- puis `make login`

### Le fichier `.local/keys/init.txt` est perdu

Si les donnees `vault-data/` existent toujours mais que le fichier de cles locales est perdu, le lab ne pourra plus etre descele de facon simple.

La solution la plus simple pour ce repo d'apprentissage est:

```bash
make down
make clean
make up
make init
make unseal
make login
```

### Je veux repartir de zero

```bash
make down
make clean
```

Puis:

```bash
make up
make init
make unseal
make login
```

## Bonnes pratiques pour ce lab

- ne jamais versionner `.local/`
- ne jamais versionner `vault-data/`
- reserver ce lab a un usage local et pedagogique
- ne pas reutiliser cette configuration telle quelle en production

