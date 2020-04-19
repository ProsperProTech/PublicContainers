#!/usr/bin/env bash
# Copyright (c) 2020 Martijn Dekkers, Regulus Data Services.
# Licensed under the Apache 2.0 License
# Martijn Dekkers <martijn@regulusdata.services>

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
