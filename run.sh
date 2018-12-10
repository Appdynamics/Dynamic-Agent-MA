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

    docker run -d --env-file=controller.env --expose "9090" --volume=/:/hostroot:ro --volume "/var/run/docker.sock:/var/run/docker.sock" \
      --hostname machine-agent --name machine-agent machine-agent

  fi

fi