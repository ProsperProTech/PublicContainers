#!/usr/bin/dumb-init /bin/bash
set -e
scripts_dir='/opt/nifi/scripts'

# For DCOS if we don't specify the Consul and Vault addresses, grab the agent the container runs on.
if [[ -z CONSUL_HTTP_ADDR ]]; then
  export CONSUL_HTTP_ADDR=${HOST}
fi

if [[ -z VAULT_ADDR ]]; then
  export VAULT_ADDR=${HOST}
fi

exec ${scripts_dir}/consul-template --config=${scripts_dir}/config.hcl
