## Dependencies

- Docker - [URL](https://docs.docker.com/engine/install/debian/)
- Docker Compose - [URL](https://docs.docker.com/compose/install/)
- JSON Query - JQ - [URL](https://stedolan.github.io/jq/)

```
bash src/install-vault.sh
sudo apt install jq docker-ce docker-compose
```

## Launch service
```
bash src/launch.sh
```

## Unseal it
```
bash src/init.sh
bash src/unseal.sh
```

## Or

- Downloads complex - [URL](https://www.vaultproject.io/downloads)
- Downloads direct - [URL](https://releases.hashicorp.com/vault/)
- Vault in development mode - [URL](https://learn.hashicorp.com/tutorials/vault/getting-started-dev-server?in=vault/getting-started)

## Use

```
source src/settings
vault status
```
Tutorials - [URL](https://learn.hashicorp.com/vault)
