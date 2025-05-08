#!/bin/bash
docker network create monitoring
docker run -d --name prometheus --network monitoring -p 9090:9090 \
  -v prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus
docker run -d --name grafana --network monitoring -p 3000:3000 grafana/grafana
