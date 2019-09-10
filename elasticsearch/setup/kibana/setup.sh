#!/usr/bin/env bash

chown -R kibana /usr/share/kibana/*

yes Y | /usr/share/kibana/bin/kibana-keystore create --allow-root

echo "${ELASTIC_USERNAME:=elastic}" | /usr/share/kibana/bin/kibana-keystore add elasticsearch.username --allow-root
echo "${ELASTIC_PASSWORD:=prosper}" | /usr/share/kibana/bin/kibana-keystore add elasticsearch.password --allow-root

printf "prosper\n" | sudo -u kibana /usr/share/kibana/bin/kibana --allow-root
