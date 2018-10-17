#!/bin/bash

if [ ! -f .env ]
then

  echo "You must include a .env file"

else

  export $(cat .env | xargs)

  docker run -d -e "CONTROLLER_HOST=$CONTROLLER_HOST" -e "CONTROLLER_PORT=$CONTROLLER_PORT" -e "CONTROLLER_SSL_ENABLED=$CONTROLLER_SSL_ENABLED" \
		-e "APPLICATION_NAME=$APPLICATION_NAME" -e "ACCOUNT_NAME=$ACCOUNT_NAME" -e "ACCOUNT_ACCESS_KEY=$ACCOUNT_ACCESS_KEY" \
		-e "EVENT_ENDPOINT=$EVENT_ENDPOINT" -e "FULL_ACCOUNT_NAME=$FULL_ACCOUNT_NAME" -e "TIER_NAME_FROM=$TIER_NAME_FROM" -e "TIER_NAME_PARAM=$TIER_NAME_PARAM" \
		--expose "9090" --network=$NETWORK_NAME --hostname machine-agent \
		--volume "/var/run/docker.sock:/var/run/docker.sock" --name machine-agent machine-agent

fi