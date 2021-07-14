#!/bin/sh

docker_run="docker run"
docker_env=""

if [ -n "$INPUT_SKIP_SETCAP" ]; then
  docker_env="$docker_env -e SKIP_SETCAP=$INPUT_SKIP_SETCAP"
fi

if [ -n "$INPUT_VAULT_TOKEN" ]; then
  docker_env="$docker_env -e VAULT_TOKEN=$INPUT_VAULT_TOKEN"
fi

if [ -n "$INPUT_VAULT_DEV_ROOT_TOKEN_ID" ]; then
  docker_env="$docker_env -e VAULT_DEV_ROOT_TOKEN_ID=$INPUT_VAULT_DEV_ROOT_TOKEN_ID"
fi

if [ -n "$INPUT_VAULT_ADDR" ]; then
  docker_env="$docker_env -e VAULT_ADDR=$INPUT_VAULT_ADDR"
fi

docker_run="$docker_run $docker_env -d -p 8200:8200 vault:0.11.4"

sh -c "$docker_run"

echo "started vault"

DOCKER_VAULT_ID=`docker ps | grep vault  | awk '{ print $1 }'`


init_vault="vault secrets disable secret \
&& vault secrets enable -path=secret -version=1 kv \
&& vault secrets enable totp"

docker exec $docker_env ${DOCKER_VAULT_ID} sh -c "$init_vault"
