#!/bin/bash

if [ ! -f controller.env ]
then

  echo "You must include a controller.env file"

else

  docker pull jdbarfield/dynamic-attach-ma
  docker tag jdbarfield/dynamic-attach-ma machine-agent

  export $(cat controller.env | xargs)

  if [[ "x$CONTROLLER_HOST" == "x" || "x$CONTROLLER_PORT" == "x" || "x$CONTROLLER_SSL_ENABLED" == "x" || "x$APPLICATION_NAME" == "x" || "x$ACCOUNT_ACCESS_KEY" == "x" ]]; then

    echo "CONTROLLER_HOST, CONTROLLER_PORT, CONTROLLER_SSL_ENABLED, APPLICATION_NAME, ACCOUNT_NAME, and ACCOUNT_ACCESS_KEY are required"

  else

    docker run -d -e "CONTROLLER_HOST=$CONTROLLER_HOST" -e "CONTROLLER_PORT=$CONTROLLER_PORT" -e "CONTROLLER_SSL_ENABLED=$CONTROLLER_SSL_ENABLED" \
      -e "APPLICATION_NAME=$APPLICATION_NAME" -e "ACCOUNT_NAME=$ACCOUNT_NAME" -e "ACCOUNT_ACCESS_KEY=$ACCOUNT_ACCESS_KEY" \
      -e "EVENT_ENDPOINT=$EVENT_ENDPOINT" -e "FULL_ACCOUNT_NAME=$FULL_ACCOUNT_NAME" -e "ENABLE_NODEJS_INJECTION=$ENABLE_NODEJS_INJECTION" \
      -e "TIER_NAME_FROM=$TIER_NAME_FROM" -e "TIER_NAME_PARAM=$TIER_NAME_PARAM" --expose "9090"  --volume "/var/run/docker.sock:/var/run/docker.sock" \
      --hostname machine-agent --name machine-agent machine-agent

  fi
	
fi
