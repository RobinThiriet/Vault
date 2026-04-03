# Atelier 01 - KV v2, Policy et Token

Cet atelier te fait manipuler trois briques essentielles de Vault:

- un moteur de secrets `KV v2`
- une `policy`
- un `token` limite par cette policy

## Prerequis

Le lab Docker doit etre demarre et Vault doit etre initialisé, descellé et accessible:

```bash
make up
make init
make unseal
make login
make status
```

## Objectif

A la fin de l'atelier, tu sauras:

- activer un moteur KV v2
- ecrire et lire un secret
- creer une policy de lecture
- generer un token limite
- verifier qu'un token restreint ne peut pas ecrire

## Etape 1 - Ouvrir un shell dans Vault

```bash
make shell
export VAULT_ADDR=http://127.0.0.1:8200
```

Tu peux verifier ton contexte:

```bash
vault status
vault token lookup
```

## Etape 2 - Activer le moteur KV v2

```bash
vault secrets enable -path=secret kv-v2
```

Resultat attendu:

- le chemin `secret/` est cree
- Vault confirme l'activation du moteur

Verification:

```bash
vault secrets list
```

## Etape 3 - Ecrire un premier secret

```bash
vault kv put secret/demo username=robin password=test123 env=lab
```

Verification:

```bash
vault kv get secret/demo
```

Tu dois voir les champs:

- `username`
- `password`
- `env`

## Etape 4 - Lire les metadonnees et la version

KV v2 gere les versions des secrets.

```bash
vault kv metadata get secret/demo
```

Puis modifie le secret:

```bash
vault kv put secret/demo username=robin password=test456 env=lab
```

Relis ensuite le secret:

```bash
vault kv get secret/demo
```

Tu dois observer que la version a change.

## Etape 5 - Creer une policy de lecture seule

Le repo contient deja une policy minimale:

```bash
cat /workspace/policies/dev-read-demo.hcl
```

Charge-la dans Vault:

```bash
vault policy write dev-read /workspace/policies/dev-read-demo.hcl
```

Verification:

```bash
vault policy read dev-read
```

## Etape 6 - Creer un token limite

```bash
vault token create -policy=dev-read
```

Recupere le token affiche et exporte-le dans une variable de shell:

```bash
export LIMITED_TOKEN="colle-le-token-ici"
```

Teste la lecture avec ce token:

```bash
VAULT_TOKEN="$LIMITED_TOKEN" vault kv get secret/demo
```

## Etape 7 - Verifier la restriction

Essaie maintenant une ecriture avec ce meme token:

```bash
VAULT_TOKEN="$LIMITED_TOKEN" vault kv put secret/demo test=ko
```

Resultat attendu:

- la lecture fonctionne
- l'ecriture echoue avec une erreur de permission

## Etape 8 - Revenir au token root

Si besoin, reconnecte-toi avec le token root stocke localement:

```bash
exit
make login
make shell
export VAULT_ADDR=http://127.0.0.1:8200
vault token lookup
```

## Ce que tu viens d'apprendre

- `KV v2` stocke et versionne les secrets
- les `policies` controlent finement les actions possibles
- les `tokens` portent les permissions attachees aux policies

## Nettoyage optionnel

Supprimer le secret:

```bash
vault kv metadata delete secret/demo
```

Supprimer la policy:

```bash
vault policy delete dev-read
```

Desactiver le moteur:

```bash
vault secrets disable secret
```

## Suite recommandee

Apres cet atelier, la meilleure suite est:

1. un atelier AppRole
2. un atelier Transit
3. un atelier PKI
