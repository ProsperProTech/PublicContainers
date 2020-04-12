# Copyright (c) 2020 Martijn Dekkers, Regulus Data Services.
# Licensed under the Apache 2.0 License
# Martijn Dekkers <martijn@regulusdata.services>

###
# Fetch all the config templates from Consul
###
template {
    contents = "{{ printf \"%s/authorizers.xml.ctmpl\" (env \"NIFI_TMPL_SRC_PATH\") | key }}"
    destination = "/var/tmp/authorizers.xml.ctmpl"
    error_on_missing_key = true
}

template {
    contents = "{{ printf \"%s/bootstrap.conf.ctmpl\" (env \"NIFI_TMPL_SRC_PATH\") | key }}"
    destination = "/var/tmp/bootstrap.conf.ctmpl"
    error_on_missing_key = true
}

template {
    contents = "{{ printf \"%s/bootstrap-notification-services.xml.ctmpl\" (env \"NIFI_TMPL_SRC_PATH\") | key }}"
    destination = "/var/tmp/bootstrap-notification-services.xml.ctmpl"
    error_on_missing_key = true
}

template {
    contents = "{{ printf \"%s/login-identity-providers.xml.ctmpl\" (env \"NIFI_TMPL_SRC_PATH\") | key }}"
    destination = "/var/tmp/login-identity-providers.xml.ctmpl"
    error_on_missing_key = true
}

template {
    contents = "{{ printf \"%s/nifi.properties.ctmpl\" (env \"NIFI_TMPL_SRC_PATH\") | key }}"
    destination = "/var/tmp/nifi.properties.ctmpl"
    error_on_missing_key = true
}

template {
    contents = "{{ printf \"%s/state-management.xml\" (env \"NIFI_TMPL_SRC_PATH\") | key }}"
    destination = "/var/tmp/state-management.xml"
    error_on_missing_key = true
    command = "mv -f /var/tmp/state-management.xml ${NIFI_CONF_DST_DIR}/state-management.xml"
}

template {
    contents = "{{ printf \"%s/zookeeper.properties.ctmpl\" (env \"NIFI_TMPL_SRC_PATH\") | key }}"
    destination = "/var/tmp/zookeeper.properties.ctmpl"
    error_on_missing_key = true
}

template {
    contents = "{{ printf \"%s/logback.xml\" (env \"NIFI_TMPL_SRC_PATH\") | key }}"
    destination = "/var/tmp/logback.xml"
    error_on_missing_key = true
    command = "mv -f /var/tmp/logback.xml ${NIFI_CONF_DST_DIR}/logback.xml"
}

template {
    contents = "{{ printf \"%s/cert.ctmpl\" (env \"TLS_TMPL_SRC_PATH\") | key }}"
    destination = "/var/tmp/cert.crt.ctmpl"
    error_on_missing_key = true
}

template {
    contents = "{{ printf \"%s/ca.ctmpl\" (env \"TLS_TMPL_SRC_PATH\") | key }}"
    destination = "/var/tmp/ca.crt.ctmpl"
    error_on_missing_key = true
}

template {
    contents = "{{ printf \"%s/private_key.ctmpl\" (env \"TLS_TMPL_SRC_PATH\") | key }}"
    destination = "/var/tmp/private_key.rsa.ctmpl"
    error_on_missing_key = true
}
