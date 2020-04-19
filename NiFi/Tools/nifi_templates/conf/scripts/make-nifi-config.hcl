# Copyright (c) 2020 Martijn Dekkers, Regulus Data Services.
# Licensed under the Apache 2.0 License
# Martijn Dekkers <martijn@regulusdata.services>

###
# Required Environment Variables:
#  Scripts:
#    SCRIPT_SRC_PATH: Path in Consul where the scripts reside
#    SCRIPTS_DIR: Directory in the container where the scripts should reside
#
#  NiFi Configuration:
#    NIFI_TMPL_SRC_PATH: Path in Consul where the nifi configuration templates reside
#    NIFI_CONF_DST_DIR: Directory in the container where the nifi configuration files should reside
#
#  TLS Certificates:
#    TLS_TMPL_SRC_PATH: Path in Consul where the TLS templates reside
#    TLS_CERT_DST_DIR: Directory in the container where the TLS certificates should reside
###

###
# Configure consul-template
###
reload_signal = "SIGHUP"
kill_signal = "SIGINT"
max_stale = "10m"
log_level = "info"

wait {
    min = "5s"
    max = "10s"
}

vault {
    renew_token = false
}

deduplicate {
    enabled = true
}

###
# Get the nifi start script from Consul
###
template {
    contents = "{{ printf \"%s/start.sh.ctmpl\" (env \"SCRIPT_SRC_PATH\") | key }}"
    destination = "./tmp/start.sh"
    error_on_missing_key = true
    command = "mv -f ./tmp/start.sh ${SCRIPTS_DIR}/start.sh"

}

###
# Fetch all the config templates from Consul, render those that want rendering
###
template {
    contents = "{{ printf \"%s/authorizers.xml.ctmpl\" (env \"NIFI_TMPL_SRC_PATH\") | key }}"
    destination = "./tmp/authorizers.xml"
    error_on_missing_key = true
    command = "mv -f ./tmp/authorizers.xml ${NIFI_CONF_DST_DIR}/authorizers.xml"
}

template {
    contents = "{{ printf \"%s/bootstrap.conf.ctmpl\" (env \"NIFI_TMPL_SRC_PATH\") | key }}"
    destination = "./tmp/bootstrap.conf"
    error_on_missing_key = true
    command = "mv -f ./tmp/bootstrap.conf ${NIFI_CONF_DST_DIR}/bootstrap.conf"
}

template {
    contents = "{{ printf \"%s/bootstrap-notification-services.xml.ctmpl\" (env \"NIFI_TMPL_SRC_PATH\") | key }}"
    destination = "./tmp/bootstrap-notification-services.xml"
    error_on_missing_key = true
    command = "mv -f ./tmp/bootstrap-notification-services.xml ${NIFI_CONF_DST_DIR}/bootstrap-notification-services.xml"
}

template {
    contents = "{{ printf \"%s/login-identity-providers.xml.ctmpl\" (env \"NIFI_TMPL_SRC_PATH\") | key }}"
    destination = "./tmp/login-identity-providers.xml"
    error_on_missing_key = true
    command = "mv -f ./tmp/login-identity-providers.xml ${NIFI_CONF_DST_DIR}/login-identity-providers.xml"
}

template {
    contents = "{{ printf \"%s/nifi.properties.ctmpl\" (env \"NIFI_TMPL_SRC_PATH\") | key }}"
    destination = "./tmp/nifi.properties"
    error_on_missing_key = true
    command = "mv -f ./tmp/nifi.properties ${NIFI_CONF_DST_DIR}/nifi.properties"
}

template {
    contents = "{{ printf \"%s/state-management.xml\" (env \"NIFI_TMPL_SRC_PATH\") | key }}"
    destination = "./tmp/state-management.xml"
    error_on_missing_key = true
    command = "mv -f ./tmp/state-management.xml ${NIFI_CONF_DST_DIR}/state-management.xml"
}

template {
    contents = "{{ printf \"%s/zookeeper.properties.ctmpl\" (env \"NIFI_TMPL_SRC_PATH\") | key }}"
    destination = "./tmp/zookeeper.properties.ctmpl"
    error_on_missing_key = true
}

template {
    contents = "{{ printf \"%s/logback.xml\" (env \"NIFI_TMPL_SRC_PATH\") | key }}"
    destination = "./tmp/logback.xml"
    error_on_missing_key = true
}

###
# Render all the config files
###
template {
    source = "./tmp/authorizers.xml.ctmpl"
    destination = "{{ printf \"%s/authorizers.xml\" (env \"NIFI_CONF_DST_DIR\") | key }}"
}

template {
    contents = "{{ printf \"%s/bootstrap.conf.ctmpl\" (env \"NIFI_CONF_DST_DIR\") | key }}"
    destination = "{{ printf \"%s/bootstrap.conf\" (env \"NIFI_CONF_DST_DIR\") | key }}"
}

template {
    contents = "{{ printf \"%s/bootstrap-notification-services.xml.ctmpl\" (env \"NIFI_CONF_DST_DIR\") | key }}"
    destination = "{{ printf \"%s/bootstrap-notification-services.xml\" (env \"NIFI_CONF_DST_DIR\") | key }}"
}

template {
    contents = "{{ printf \"%s/login-identity-providers.xml.ctmpl\" (env \"NIFI_CONF_DST_DIR\") | key }}"
    destination = "{{ printf \"%s/login-identity-providers.xml\" (env \"NIFI_CONF_DST_DIR\") | key }}"
}

template {
    contents = "{{ printf \"%s/nifi.properties.ctmpl\" (env \"NIFI_CONF_DST_DIR\") | key }}"
    destination = "{{ printf \"%s/nifi.properties\" (env \"NIFI_CONF_DST_DIR\") | key }}"
}

template {
    contents = "{{ printf \"%s/zookeeper.properties.ctmpl\" (env \"NIFI_CONF_DST_DIR\") | key }}"
    destination = "{{ printf \"%s/zookeeper.properties\" (env \"NIFI_CONF_DST_DIR\") | key }}"
}

###
# Get certificates
###
template {
    source = "{{ printf \"%s/cert.ctmpl\" (env \"TLS_TMPL_SRC_PATH\") | key }}"
    destination = "{{ printf \"%s/cert.crt\" (env \"TLS_CERT_DST_DIR\") | key }}"
}

template {
    source = "{{ printf \"%s/ca.ctmpl\" (env \"TLS_TMPL_SRC_PATH\") | key }}"
    destination = "{{ printf \"%s/ca.crt\" (env \"TLS_CERT_DST_DIR\") | key }}"
}

template {
    source = "{{ printf \"%s/key.ctmpl\" (env \"TLS_TMPL_SRC_PATH\") | key }}"
    destination = "{{ printf \"%s/private_key.rsa\" (env \"TLS_CERT_DST_DIR\") | key }}"
}

###
# The configuration is prepared, hand over to the start script
###
exec {
    command = "/bin/bash -c '/opt/nifi/scripts/start.sh'"
}
