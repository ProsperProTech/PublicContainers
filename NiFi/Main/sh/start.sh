#!/usr/bin/env bash
# Copyright (c) 2020 Martijn Dekkers, Regulus Data Services.
# Licensed under the Apache 2.0 License
# Martijn Dekkers <martijn@regulusdata.services>

# Load script variables
scripts_dir='/opt/nifi/scripts'
# conf_dir="/mnt/mesos/sandbox/conf"

# set bash debug
if [[ ${DEBUG} == "True" ]]; then
	set -x
fi

prdebug(){
	if [[ ${DEBUG} == "True" ]];then
		echo "[DEBUG] [$(date +%F\ %T)] $1 $2"
	fi
}

# Work around NiFi bug 4685 to work with a different location for conf directory.
mv /opt/nifi/nifi-current/conf /opt/nifi/nifi-current/conf.moved
ln -s ${CONF_DIR} /opt/nifi/nifi-current/conf
chown -R nifi: /opt/nifi/nifi-current/conf
chown -R nifi: ${CONF_DIR}

makecert(){



	mv "${HOSTNAME}"/keystore.jks "${NF_KEYS_PATH}"/keystore.jks
	mv "${HOSTNAME}"/truststore.jks "${NF_KEYS_PATH}"/truststore.jks

	NIFI_SECURITY_KEYSTOREPASSWD="$(grep keystorePasswd "${HOSTNAME}"/nifi.properties | cut -d"=" -f2)"
	NIFI_SECURITY_KEYPASSWD="$(grep keyPasswd "${HOSTNAME}"/nifi.properties | cut -d"=" -f2)"
	NIFI_SECURITY_TRUSTSTOREPASSWD="$(grep truststorePasswd "${HOSTNAME}"/nifi.properties | cut -d"=" -f2)"
	NIFI_SECURITY_KEYSTORETYPE="$(grep keystoreType "${HOSTNAME}"/nifi.properties | cut -d"=" -f2)"
	NIFI_SECURITY_TRUSTSTORETYPE="$(grep truststoreType "${HOSTNAME}"/nifi.properties | cut -d"=" -f2)"
	NIFI_SECURITY_TRUSTSTORE="${NF_KEYS_PATH}/truststore.jks"
	NIFI_SECURITY_KEYSTORE="${NF_KEYS_PATH}/keystore.jks"

	export NIFI_SECURITY_KEYSTOREPASSWD
	export NIFI_SECURITY_KEYPASSWD
	export NIFI_SECURITY_TRUSTSTOREPASSWD
	export NIFI_SECURITY_KEYSTORETYPE
	export NIFI_SECURITY_TRUSTSTORETYPE
	export NIFI_SECURITY_TRUSTSTORE
	export NIFI_SECURITY_KEYSTORE

}

makeconfig(){

	# We need some variables wrangled
	# TODO: FixMe - make HTTP and HTTPS versions
	NIFI_WEB_PROXY_HOST="${HOSTNAME}:${NIFI_WEB_HTTPS_PORT},${NIFI_WEB_PROXY_HOST}"

	# Build the nifi.properties file, remove it if present
	if [[ -f ${conf_dir}/nifi.properties ]];then
		rm -f ${conf_dir}/nifi.properties
	fi

  # Build the other config files from envvars
	${scripts_dir}/j2 --undefined "${NIFI_HOME}"/conf.moved/bootstrap.conf.j2 -o ${conf_dir}/bootstrap.conf
	${scripts_dir}/j2 --undefined "${NIFI_HOME}"/conf.moved/nifi.properties.j2 -o ${conf_dir}/nifi.properties
	${scripts_dir}/j2 --undefined "${NIFI_HOME}"/conf.moved/login-identity-providers.xml.j2 -o ${conf_dir}/login-identity-providers.xml
	${scripts_dir}/j2 --undefined "${NIFI_HOME}"/conf.moved/authorizers.xml.j2 -o ${conf_dir}/authorizers.xml
	${scripts_dir}/j2 --undefined "${NIFI_HOME}"/conf.moved/zookeeper.properties.j2 -o ${conf_dir}/zookeeper.properties
  cp "${NIFI_HOME}"/conf.moved/bootstrap-notification-services.xml ${conf_dir}/bootstrap-notification-services.xml
  cp "${NIFI_HOME}"/conf.moved/logback.xml ${conf_dir}/logback.xml
  cp "${NIFI_HOME}"/conf.moved/state-management.xml ${conf_dir}/state-management.xml
}

showconfig(){
	# print config information if the DEBUG var is set to True
	prdebug "NiFi properties:"
	prdebug "$(cat ${conf_dir}/nifi.properties)"
	prdebug " "
		prdebug "Bootstrap Config"
	prdebug "$(cat ${conf_dir}/bootstrap.conf)"
	prdebug " "
		prdebug "Login ID Providers:"
	prdebug "$(cat ${conf_dir}/login-identity-providers.xml)"
	prdebug " "
		prdebug "Authorizers:"
	prdebug "$(cat ${conf_dir}/authorizers.xml)"
	prdebug " "
		prdebug "Zookeeper properties:"
	prdebug "$(cat ${conf_dir}/zookeeper.properties)"
	prdebug " "
}

makecert
makeconfig
showconfig

#unset bash debug
if [[ ${DEBUG} == "True" ]]; then
	set +x
fi


# Run NiFi
tail -F "${NIFI_HOME}/logs/nifi-app.log" &
"${NIFI_HOME}/bin/nifi.sh" run &
nifi_pid="$!"

trap "echo Received trapped signal, beginning shutdown...;" KILL TERM HUP INT EXIT;

echo NiFi running with PID ${nifi_pid}.
wait ${nifi_pid}
