#!/usr/bin/dumb-init /bin/bash
# Copyright (c) 2020 Martijn Dekkers, Regulus Data Services.
# Licensed under the Apache 2.0 License
# Martijn Dekkers <martijn@regulusdata.services>

###
# Required Environment Variables:
#  Consul / Vault locations:
#    CONSUL_HTTP_ADDR: URL for the Consul cluster. If not set, the script will use the IP of the local host
#                      Must be in this format: "192.168.86.189:8500"
#    CONSUL_HTTP_TOKEN: Login token for the Consul service
#    VAULT_ADDR: URL for the Vault cluster. If not set, the script will use the IP of the local host
#                Must be in this format: "http://192.168.86.189:8200"
#    VAULT_TOKEN: Login token for the Vault service
#
#  Consul config:
#    SCRIPTS_DIR: Directory in the container where the scripts should reside
#    CONSUL_CONFIG_URL: If present, pull the Consul configuration file from this URL.
###

###
# Exit immediately if a pipeline returns a non-zero status
###
set -e

##
# Keep this file as simple as possible, fetch everything else from Consul.
# For DCOS if we don't specify the Consul and Vault addresses, grab the agent the container runs on.
##
if [[ -z CONSUL_HTTP_ADDR ]]; then
  export CONSUL_HTTP_ADDR=${HOST}
fi

if [[ -z VAULT_ADDR ]]; then
  export VAULT_ADDR=${HOST}
fi

###
# If the user wants a custom consul config, fetch and use it from an HTTP/S location
###
if [[ CONSUL_CONFIG_URL ]]; then
  cp ${SCRIPTS_DIR}/make-nifi-config.hcl ${SCRIPTS_DIR}/make-nifi-config.hcl.orig
  curl -fSL ${CONSUL_CONFIG_URL} -o ${SCRIPTS_DIR}/make-nifi-config.hcl
fi

###
# Run consul-template to get everything configured
###
exec ${SCRIPTS_DIR}/consul-template --config=${SCRIPTS_DIR}/make-nifi-config.hcl
