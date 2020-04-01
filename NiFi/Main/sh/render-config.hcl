# Copyright (c) 2020 Martijn Dekkers, Regulus Data Services.
# Licensed under the Apache 2.0 License
# Martijn Dekkers <martijn@regulusdata.services>

###
# Render config files
###
template {
    source = "/var/tmp/authorizers.xml.ctmpl"
    destination = "{{ printf \"%s/authorizers.xml\" (env \"NIFI_CONF_DST_DIR\") | key }}"
}

template {
    source = "/var/tmp/bootstrap.conf.ctmpl"
    destination = "{{ printf \"%s/bootstrap.conf\" (env \"NIFI_CONF_DST_DIR\") | key }}"
}

template {
    source = "/var/tmp/bootstrap-notification-services.xml.ctmpl"
    destination = "{{ printf \"%s/bootstrap-notification-services.xml\" (env \"NIFI_CONF_DST_DIR\") | key }}"
}

template {
    source = "/var/tmp/logback.xml.ctmpl"
    destination = "{{ printf \"%s/logback.xml\" (env \"NIFI_CONF_DST_DIR\") | key }}"
}

template {
    source = "/var/tmp/login-identity-providers.xml.ctmpl"
    destination = "{{ printf \"%s/login-identity-providers.xml\" (env \"NIFI_CONF_DST_DIR\") | key }}"
}

template {
    source = "/var/tmp/nifi.properties.ctmpl"
    destination = "{{ printf \"%s/nifi.properties\" (env \"NIFI_CONF_DST_DIR\") | key }}"
}

template {
    source = "/var/tmp/state-management.xml.ctmpl"
    destination = "{{ printf \"%s/state-management.xml\" (env \"NIFI_CONF_DST_DIR\") | key }}"
}

template {
    source = "/var/tmp/zookeeper.properties.ctmpl"
    destination = "{{ printf \"%s/zookeeper.properties\" (env \"NIFI_CONF_DST_DIR\") | key }}"
}

###
# Render certificates
###
template {
    source = "/var/tmp/cert.crt"
    destination = "{{ printf \"%s/cert.crt\" (env \"TLS_CERT_DST_DIR\") | key }}"
}

template {
    source = "/var/tmp/ca.crt"
    destination = "{{ printf \"%s/ca.crt\" (env \"TLS_CERT_DST_DIR\") | key }}"
}

template {
    source = "/var/tmp/private_key.rsa"
    destination = "{{ printf \"%s/private_key.rsa\" (env \"TLS_CERT_DST_DIR\") | key }}"
}