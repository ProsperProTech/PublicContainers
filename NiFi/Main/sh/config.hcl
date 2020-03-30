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
    # prefix = "consul-template/dedup/"
}

###
# Fetch all the config templates from Consul
###
template {
    contents = "{{ printf \"%s/authorizers.xml.ctmpl\" (env \"CNFSRCPATH\") | key }}"
    destination = "{{ printf \"%s/authorizers.xml.ctmpl\" (env \"CNFDSTPATH\") | key }}"
    error_on_missing_key = true
}

template {
    contents = "{{ printf \"%s/bootstrap.conf.ctmpl\" (env \"CNFSRCPATH\") | key }}"
    destination = "{{ printf \"%s/bootstrap.conf.ctmpl\" (env \"CNFDSTPATH\") | key }}"
    error_on_missing_key = true
}

template {
    contents = "{{ printf \"%s/bootstrap-notification-services.xml.ctmpl\" (env \"CNFSRCPATH\") | key }}"
    destination = "{{ printf \"%s/bootstrap-notification-services.xml.ctmpl\" (env \"CNFDSTPATH\") | key }}"
    error_on_missing_key = true
}

template {
    contents = "{{ printf \"%s/login-identity-providers.xml.ctmpl\" (env \"CNFSRCPATH\") | key }}"
    destination = "{{ printf \"%s/login-identity-providers.xml.ctmpl\" (env \"CNFDSTPATH\") | key }}"
    error_on_missing_key = true
}

template {
    contents = "{{ printf \"%s/nifi.properties.ctmpl\" (env \"CNFSRCPATH\") | key }}"
    destination = "{{ printf \"%s/nifi.properties.ctmpl\" (env \"CNFDSTPATH\") | key }}"
    error_on_missing_key = true
}

template {
    contents = "{{ printf \"%s/state-management.xml\" (env \"CNFSRCPATH\") | key }}"
    destination = "{{ printf \"%s/state-management.xml\" (env \"CNFDSTPATH\") | key }}"
    error_on_missing_key = true
}

template {
    contents = "{{ printf \"%s/zookeeper.properties.ctmpl\" (env \"CNFSRCPATH\") | key }}"
    destination = "{{ printf \"%s/zookeeper.properties.ctmpl\" (env \"CNFDSTPATH\") | key }}"
    error_on_missing_key = true
}

template {
    contents = "{{ printf \"%s/logback.xml\" (env \"CNFSRCPATH\") | key }}"
    destination = "{{ printf \"%s/logback.xml\" (env \"CNFDSTPATH\") | key }}"
    error_on_missing_key = true
}

###
# Render all the config files
###
template {
    source = "{{ printf \"%s/authorizers.xml.ctmpl\" (env \"CNFDSTPATH\") | key }}"
    destination = "{{ printf \"%s/authorizers.xml\" (env \"CNFDSTPATH\") | key }}"
}

template {
    contents = "{{ printf \"%s/bootstrap.conf.ctmpl\" (env \"CNFDSTPATH\") | key }}"
    destination = "{{ printf \"%s/bootstrap.conf\" (env \"CNFDSTPATH\") | key }}"
}

template {
    contents = "{{ printf \"%s/bootstrap-notification-services.xml.ctmpl\" (env \"CNFDSTPATH\") | key }}"
    destination = "{{ printf \"%s/bootstrap-notification-services.xml\" (env \"CNFDSTPATH\") | key }}"
}

template {
    contents = "{{ printf \"%s/login-identity-providers.xml.ctmpl\" (env \"CNFDSTPATH\") | key }}"
    destination = "{{ printf \"%s/login-identity-providers.xml\" (env \"CNFDSTPATH\") | key }}"
}

template {
    contents = "{{ printf \"%s/nifi.properties.ctmpl\" (env \"CNFDSTPATH\") | key }}"
    destination = "{{ printf \"%s/nifi.properties\" (env \"CNFDSTPATH\") | key }}"
}

template {
    contents = "{{ printf \"%s/zookeeper.properties.ctmpl\" (env \"CNFDSTPATH\") | key }}"
    destination = "{{ printf \"%s/zookeeper.properties\" (env \"CNFDSTPATH\") | key }}"
}

###
# Get certificates
###
template {
    source = "{{ printf \"%s/cert.ctmpl\" (env \"CNFDSTPATH\") | key }}"
    destination = "{{ printf \"%s/cert.crt\" (env \"CNFDSTPATH\") | key }}"
}

template {
    source = "{{ printf \"%s/ca.ctmpl\" (env \"CNFDSTPATH\") | key }}"
    destination = "{{ printf \"%s/ca.crt\" (env \"CNFDSTPATH\") | key }}"
}

template {
    source = "{{ printf \"%s/key.ctmpl\" (env \"CNFDSTPATH\") | key }}"
    destination = "{{ printf \"%s/private_key.rsa\" (env \"CNFDSTPATH\") | key }}"
}
exec {
    command = "/bin/bash -c '../scripts/start.sh'"
}
