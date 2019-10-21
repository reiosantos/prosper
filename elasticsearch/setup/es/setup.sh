#!/usr/bin/env bash

RANDOM_NODE="node-$RANDOM"
NODE_NAME="${ELASTIC_NODE_NAME:=$RANDOM_NODE}"
ELASTIC_PASSWORD="${ELASTIC_PASSWORD:=prosper}"

if [[ ${ELASTIC_NODE_MASTER:=false} == true && (! -f /opt/cert_blog/certs.zip || ! -d /opt/cert_blog/certs) ]]; then
	printf "Generating certificates in node: %s..............\n" "${NODE_NAME}"
	# Generate CA and server certificates
	mkdir -p /opt/cert_blog
	/usr/share/elasticsearch/bin/elasticsearch-certutil cert ca --pem --in /opt/elastic/instances.yml --out /opt/cert_blog/certs.zip
	cd /opt/cert_blog || exit
	unzip certs.zip -d ./certs
	printf "Done creating certificates..............\n"
fi

# Elasticsearch TLS setup
cd /etc/elasticsearch || exit

if [[ ! -d '/etc/elasticsearch/certs' ]]; then
	mkdir certs
fi

cp /opt/cert_blog/certs/ca/ca.crt /opt/cert_blog/certs/${NODE_NAME}/* certs

if [[ ! -d '/usr/share/elasticsearch/data/' ]]; then
	mkdir /usr/share/elasticsearch/data/
fi

chown -R elasticsearch /usr/share/elasticsearch/*

yes Y | /usr/share/elasticsearch/bin/elasticsearch-keystore create

# setup user for elasticsearch
echo "${ELASTIC_PASSWORD}" | /usr/share/elasticsearch/bin/elasticsearch-keystore add --stdin "bootstrap.password"

cd /opt/elastic/ || exit

cp elasticsearch.yml elasticsearch-${NODE_NAME}.yml

sed -ie "s/'node.name'/${NODE_NAME}/g" elasticsearch-${NODE_NAME}.yml
sed -ie "s/'node.master'/${ELASTIC_NODE_MASTER:=false}/g" elasticsearch-${NODE_NAME}.yml
sed -ie "s/'unicast.hosts'/${ELASTIC_UNICAST_HOSTS:=[localhost]}/g" elasticsearch-${NODE_NAME}.yml
sed -ie "s/'network.host'/${ELASTIC_HOST:=localhost}/g" elasticsearch-${NODE_NAME}.yml
sed -ie "s/'initial.master.nodes'/${ELASTIC_MASTER_NODES:=es1}/g" elasticsearch-${NODE_NAME}.yml

cp elasticsearch-${NODE_NAME}.yml /etc/elasticsearch/elasticsearch.yml

printf "prosper\n" | sudo -u elasticsearch /usr/share/elasticsearch/bin/elasticsearch
