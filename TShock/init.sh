#!/usr/bin/env bash

if [ -f ./.server-init ]; then
  echo Server started
  exit 1
fi

USER_UID=${USER_UID:-$(id -u)}

docker compose run server --create &&
  sudo chown -R "${USER_UID}:0" ./server/.docker &&
  chmod -R g+w ./server/.docker &&
  (docker swarm init 2>/dev/null || echo "swarm") &&
  (cd ./server &&
    cp swarm-dist.yml swarm.yml &&
    docker stack deploy -c swarm.yml terraria) &&
  touch ./.server-init
