# Copyright (c) 2020 Martijn Dekkers, Regulus Data Services.
# Licensed under the Apache 2.0 License
# Martijn Dekkers <martijn@regulusdata.services>

###
# Render config files
###
template {
    source = "/var/tmp/authorizers.xml.ctmpl"
    destination = "/opt/nifi/nifi-current/conf/authorizers.xml"
}

template {
    source = "/var/tmp/bootstrap.conf.ctmpl"
    destination = "/opt/nifi/nifi-current/conf/bootstrap.conf"}

template {
    source = "/var/tmp/bootstrap-notification-services.xml.ctmpl"
    destination = "/opt/nifi/nifi-current/conf/bootstrap-notification-services.xml"}

template {
    source = "/var/tmp/login-identity-providers.xml.ctmpl"
    destination = "/opt/nifi/nifi-current/conf/login-identity-providers.xml"}

template {
    source = "/var/tmp/nifi.properties.ctmpl"
    destination = "/opt/nifi/nifi-current/conf/nifi.properties"}

template {
    source = "/var/tmp/zookeeper.properties.ctmpl"
    destination = "/opt/nifi/nifi-current/conf/zookeeper.properties"}

###
# Render certificates
###
template {
    source = "/var/tmp/cert.crt.ctmpl"
    destination = "/opt/nifi/nifi-current/conf/cert.crt"}

template {
    source = "/var/tmp/ca.crt.ctmpl"
    destination = "/opt/nifi/nifi-current/conf/ca.crt"}

template {
    source = "/var/tmp/private_key.rsa.ctmpl"
    destination = "/opt/nifi/nifi-current/conf/private_key.rsa"}