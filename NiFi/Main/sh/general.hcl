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