#!/bin/bash

if [[ -z "${INFLUX_TOKEN}" ]]; then
  echo "Set your INFLUX_TOKEN!"
  exit 1
else
  echo "${INFLUX_TOKEN}"
fi

docker compose -f docker-compose.yml -f docker-compose.dummy.yml up -d

