#!/usr/bin/env bash

chown -R logstash /usr/share/logstash/*

# apm-server TLS setup
cd /etc/logstash || exit

if [[ ! -d '/etc/logstash/certs' ]]; then
	mkdir certs
fi

cp /opt/cert_blog/certs/ca/ca.crt /opt/cert_blog/certs/logstash/* certs

cd /opt/logstash || exit
cp logstash.yml /etc/logstash/logstash.yml
cp logstash.conf /etc/logstash/conf.d/logstash.conf

echo "Creating Key store......."
yes Y | /usr/share/logstash/bin/logstash-keystore create --path.settings /etc/logstash

echo "Adding credentials to Key store......."
# setup user for logstash
echo "${ELASTIC_USERNAME:=$user}" | /usr/share/logstash/bin/logstash-keystore add ELASTIC_USERNAME --path.settings /etc/logstash/
echo "${ELASTIC_PASSWORD:=$pass}" | /usr/share/logstash/bin/logstash-keystore add ELASTIC_PASSWORD --path.settings /etc/logstash/

echo "Starting LOGSTASH............"
#/usr/share/logstash/bin/logstash --path.settings /etc/logstash
/usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/logstash.conf
