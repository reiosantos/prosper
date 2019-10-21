#!/usr/bin/env bash

chown -R kibana /usr/share/kibana/*

# Kibana TLS setup
cd /etc/kibana || exit

if [[ ! -d '/etc/kibana/certs' ]]; then
	mkdir certs
fi

cp /opt/cert_blog/certs/ca/ca.crt /opt/cert_blog/certs/kibana/* certs

yes Y | /usr/share/kibana/bin/kibana-keystore create --allow-root

echo "${ELASTIC_USERNAME:=elastic}" | /usr/share/kibana/bin/kibana-keystore add elasticsearch.username --allow-root
echo "${ELASTIC_PASSWORD:=prosper}" | /usr/share/kibana/bin/kibana-keystore add elasticsearch.password --allow-root

cd /opt/kibana/ || exit

cp kibana.yml kibana-1.yml

# Sed not able to replace with non alphabet characters
#sed -ie "s/'elastic.hosts'/${ELASTIC_HOSTS:=[localhost]}/g" kibana-1.yml

sed -i '/elasticsearch.hosts/d' kibana-1.yml
echo "elasticsearch.hosts: ${ELASTIC_HOSTS:=[localhost]}" >> kibana-1.yml

cp kibana-1.yml /etc/kibana/kibana.yml

service kibana status
service kibana stop

printf "prosper\n" | sudo -u kibana /usr/share/kibana/bin/kibana
