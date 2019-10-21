#!/usr/bin/env bash

chown -R root:apm-server /usr/share/apm-server/*

# apm-server TLS setup
cd /etc/apm-server || exit

if [[ ! -d '/etc/apm-server/certs' ]]; then
	mkdir certs
fi

cp /opt/cert_blog/certs/ca/ca.crt /opt/cert_blog/certs/apm-server/* certs

yes Y | /usr/share/apm-server/bin/apm-server keystore create

# setup APM
echo "${ELASTIC_USERNAME:=elastic}" | /usr/share/apm-server/bin/apm-server keystore add elastic.username --stdin --force
echo "${ELASTIC_PASSWORD:=prosper}" | /usr/share/apm-server/bin/apm-server keystore add elastic.password --stdin --force

cd /opt/apm-server/ || exit

cp apm-server.yml /etc/apm-server/apm-server.yml

echo "Starting APM-SERVER............"
/usr/share/apm-server/bin/apm-server
