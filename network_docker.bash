#!/bin/bash
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -q) &
docker ps --format '{{.Names}}'
exec bash
