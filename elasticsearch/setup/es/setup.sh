#!/usr/bin/env bash

mkdir /usr/share/elasticsearch/data/

chown -R elasticsearch /usr/share/elasticsearch/*

yes Y | /usr/share/elasticsearch/bin/elasticsearch-keystore create

# setup user for elasticsearch
echo "${ELASTIC_PASSWORD:=prosper}" | /usr/share/elasticsearch/bin/elasticsearch-keystore add --stdin "bootstrap.password"

sed -ie "s/'node.name'/${ELASTIC_NODE_NAME:=node-$RANDOM}/g" elasticsearch.yml
sed -ie "s/'node.master'/${ELASTIC_NODE_MASTER:=false}/g" elasticsearch.yml
sed -ie "s/'unicast.hosts'/${ELASTIC_UNICAST_HOSTS:=[localhost]}/g" elasticsearch.yml
sed -ie "s/'network.host'/${ELASTIC_HOST:=localhost}/g" elasticsearch.yml
sed -ie "s/'initial.master.nodes'/${ELASTIC_MASTER_NODES:=es1}/g" elasticsearch.yml

cp elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

printf "prosper\n" | sudo -u elasticsearch /usr/share/elasticsearch/bin/elasticsearch
