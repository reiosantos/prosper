#!/usr/bin/env bash

yes n | /usr/share/elasticsearch/bin/elasticsearch-keystore create

# setup user for elasticsearch
echo "${ELASTIC_PASSWORD}" | /usr/share/elasticsearch/bin/elasticsearch-keystore add --stdin "bootstrap.password"

service elasticsearch restart
