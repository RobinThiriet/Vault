# Vault Local Lab

Base de travail pour installer HashiCorp Vault en local, s'entrainer dessus, et garder une trace proprement documentee dans Git.

## Objectifs

- demarrer Vault tres vite pour se faire la main
- comprendre le cycle reel `start -> init -> unseal -> login`
- versionner un environnement de lab simple et reproductible

## Prerequis

- Ubuntu 24.04 ou equivalent Linux
- `vault` installe localement
- acces a ce depot Git

## Version installee

Au moment de cette mise en place, Vault Community est installe localement en version `1.21.4`.

Verification:

```bash
vault version
```

## Deux modes d'entrainement

### 1. Mode dev

Le plus simple pour apprendre les commandes sans se soucier de l'initialisation. Vault demarre avec un token root fixe.

```bash
make dev-up
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root
vault status
vault secrets list
```

Arret:

```bash
make dev-down
```

### 2. Mode local persistant

Le plus utile pour comprendre un vrai cycle d'administration local:

```bash
make local-up
export VAULT_ADDR=http://127.0.0.1:8200
make local-init
make local-unseal
make local-login
vault status
```

Arret:

```bash
make local-down
```

Les donnees locales et les cles d'init sont stockees hors Git dans:

- `.runtime/`
- `.local/`

## Parcours d'apprentissage recommande

### Etape 1. Verifier l'etat du serveur

```bash
vault status
```

### Etape 2. Activer un moteur KV v2

```bash
vault secrets enable -path=secret kv-v2
```

### Etape 3. Ecrire un secret

```bash
vault kv put secret/demo username=robin password=test123
```

### Etape 4. Lire un secret

```bash
vault kv get secret/demo
```

### Etape 5. Creer une policy

```bash
cat > /tmp/dev-read.hcl <<'EOF'
path "secret/data/demo" {
  capabilities = ["read"]
}
EOF

vault policy write dev-read /tmp/dev-read.hcl
```

### Etape 6. Creer un token attache a la policy

```bash
vault token create -policy=dev-read
```

## Structure du repo

```text
config/local/vault.hcl   Configuration du serveur local persistant
scripts/dev-*.sh         Scripts pour le mode dev
scripts/local-*.sh       Scripts pour le mode local persistant
Makefile                 Raccourcis de lancement
```

## Notes utiles

- Le mode `dev` est parfait pour apprendre les commandes Vault.
- Le mode `local` est preferable pour comprendre `init`, `unseal`, le stockage et le fonctionnement d'un serveur plus realiste.
- Ce depot ignore volontairement les fichiers sensibles et temporaires.

## Prochaine suite logique

Une bonne suite pour enrichir ce repo:

1. ajouter des exercices guides
2. ajouter des policies d'exemple
3. ajouter AppRole, KV v2, Transit et PKI
4. ajouter des scripts de reset du lab
