#!/usr/bin/env bash
# Copyright (c) 2020 Martijn Dekkers, Regulus Data Services.
# Licensed under the Apache 2.0 License
# Martijn Dekkers <martijn@regulusdata.services>

readme(){
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
}

# Exit immediately if a pipeline returns a non-zero status
set -e

# If DEBUG is set, trace consul-template and bash
if [[ DEBUG ]]; then
  set -x
  ct_conf="--log-level=trace"
fi

init(){
# For DCOS if we don't specify the Consul and Vault addresses, grab the IP from the agent hosting this container.
if [[ -z CONSUL_HTTP_ADDR ]]; then
  export CONSUL_HTTP_ADDR=${HOST}
fi

if [[ -z VAULT_ADDR ]]; then
  export VAULT_ADDR=${HOST}
fi

## Work around NiFi bug 4685 to use a different location for the conf directory.
mv /opt/nifi/nifi-current/conf /opt/nifi/nifi-current/conf.orig
ln -s ${CONF_DIR} /opt/nifi/nifi-current/conf
chown -R nifi: /opt/nifi/nifi-current/conf
chown -R nifi: ${CONF_DIR}
}

buildconf(){

# First run consul-template to get all the config templates
${SCRIPTS_DIR}/consul-template --config=${SCRIPTS_DIR}/fetch-config.hcl --config=${SCRIPTS_DIR}/general.hcl --once ${ct_conf}

# Run consul-template again to render the config files
${SCRIPTS_DIR}/consul-template --config=${SCRIPTS_DIR}/render-config.hcl --config=${SCRIPTS_DIR}/general.hcl --once ${ct_conf}

# Make the certificates
# TODO Get passwords from central vault instead of local cluster vault
# TODO Adjust nifi.properties defaults to reflect TLS settings

# Make a p12 bundle of the private key and certificate
openssl pkcs12 -export -chain -CAfile ${CONF_DIR}/ca.crt -in ${CONF_DIR}/cert.crt -inkey ${CONF_DIR}/private_key.rsa -passout pass:${TLSPASS} > ${CONF_DIR}keystore.p12

# Import CA into the truststore
keytool -importcert -v -trustcacerts -alias root -file ca.crt -keystore truststore.jks -storepass ${TLSPASS} -noprompt

# Import the node certificate into the truststore
keytool -importcert -alias thisnode -file cert.crt -keystore truststore.jks -storepass ${TLSPASS} -noprompt
}

init
buildconf

#unset bash debug
if [[ ${DEBUG} == "True" ]]; then
	set +x
fi

# run nifi
"${NIFI_HOME}/bin/nifi.sh" run