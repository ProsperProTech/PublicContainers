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
    destination = "{{ printf \"%s/start.sh\" (env \"SCRIPTS_DIR\") | key }}"
    error_on_missing_key = true
}

###
# Fetch all the config templates from Consul
###
template {
    contents = "{{ printf \"%s/authorizers.xml.ctmpl\" (env \"NIFI_TMPL_SRC_PATH\") | key }}"
    destination = "{{ printf \"%s/authorizers.xml.ctmpl\" (env \"NIFI_CONF_DST_DIR\") | key }}"
    error_on_missing_key = true
}

template {
    contents = "{{ printf \"%s/bootstrap.conf.ctmpl\" (env \"NIFI_TMPL_SRC_PATH\") | key }}"
    destination = "{{ printf \"%s/bootstrap.conf.ctmpl\" (env \"NIFI_CONF_DST_DIR\") | key }}"
    error_on_missing_key = true
}

template {
    contents = "{{ printf \"%s/bootstrap-notification-services.xml.ctmpl\" (env \"NIFI_TMPL_SRC_PATH\") | key }}"
    destination = "{{ printf \"%s/bootstrap-notification-services.xml.ctmpl\" (env \"NIFI_CONF_DST_DIR\") | key }}"
    error_on_missing_key = true
}

template {
    contents = "{{ printf \"%s/login-identity-providers.xml.ctmpl\" (env \"NIFI_TMPL_SRC_PATH\") | key }}"
    destination = "{{ printf \"%s/login-identity-providers.xml.ctmpl\" (env \"NIFI_CONF_DST_DIR\") | key }}"
    error_on_missing_key = true
}

template {
    contents = "{{ printf \"%s/nifi.properties.ctmpl\" (env \"NIFI_TMPL_SRC_PATH\") | key }}"
    destination = "{{ printf \"%s/nifi.properties.ctmpl\" (env \"NIFI_CONF_DST_DIR\") | key }}"
    error_on_missing_key = true
}

template {
    contents = "{{ printf \"%s/state-management.xml\" (env \"NIFI_TMPL_SRC_PATH\") | key }}"
    destination = "{{ printf \"%s/state-management.xml\" (env \"NIFI_CONF_DST_DIR\") | key }}"
    error_on_missing_key = true
}

template {
    contents = "{{ printf \"%s/zookeeper.properties.ctmpl\" (env \"NIFI_TMPL_SRC_PATH\") | key }}"
    destination = "{{ printf \"%s/zookeeper.properties.ctmpl\" (env \"NIFI_CONF_DST_DIR\") | key }}"
    error_on_missing_key = true
}

template {
    contents = "{{ printf \"%s/logback.xml\" (env \"NIFI_TMPL_SRC_PATH\") | key }}"
    destination = "{{ printf \"%s/logback.xml\" (env \"NIFI_CONF_DST_DIR\") | key }}"
    error_on_missing_key = true
}

###
# Render all the config files
###
template {
    source = "{{ printf \"%s/authorizers.xml.ctmpl\" (env \"NIFI_CONF_DST_DIR\") | key }}"
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
