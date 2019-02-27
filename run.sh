#!/bin/bash

main() {

  if [ ! -f controller.env ]
  then

    echo "You must include a controller.env file"

  else

    docker pull appdynamics/dynamic-agent-ma:1.2.4
    docker tag appdynamics/dynamic-agent-ma:1.2.4 machine-agent

    export $(cat controller.env | xargs)

    if [[ "x$CONTROLLER_HOST" == "x" || "x$CONTROLLER_PORT" == "x" || "x$CONTROLLER_SSL_ENABLED" == "x" || "x$APPLICATION_NAME" == "x" || "x$ACCOUNT_ACCESS_KEY" == "x" ]]; then

      echo "CONTROLLER_HOST, CONTROLLER_PORT, CONTROLLER_SSL_ENABLED, APPLICATION_NAME, ACCOUNT_NAME, and ACCOUNT_ACCESS_KEY are required"

    else

      deprecatedParameterCheck

      VOLUME_MOUNT=""

      if [ -f app-agent-config.xml ]
      then

        tar -cvf extra.tar app-agent-config.xml

        VOLUME_MOUNT=" -v ${PWD}/extra.tar:/opt/machine-agent/monitors/dynamicAttach/extra.tar "

      fi

      docker run -d --env-file=controller.env $VOLUME_MOUNT --expose "9090" --dns="8.8.8.8" --volume=/:/hostroot:ro --volume "/var/run/docker.sock:/var/run/docker.sock" \
        --hostname machine-agent --name machine-agent machine-agent


      if [ -f extra.tar ]
      then

        rm extra.tar

      fi

    fi

  fi

}

deprecatedParameterCheck () {

  if [[ "x$TIER_NAME_PARAM" != "x" && "x$TIER_NAME_FROM_VALUE" == "x" ]]
  then
    echo
    echo "Warning: TIER_NAME_PARAM has been deprecated. Please use TIER_NAME_FROM_VALUE instead."
    echo
  fi

  if [[ "x$EVENT_ENDPOINT" != "x" && "x$EVENT_SERVICE_URL" == "x" ]]
  then
    echo
    echo "Warning: EVENT_ENDPOINT has been deprecated. Please use EVENT_SERVICE_URL instead."
    echo
  fi

  if [[ "x$FULL_ACCOUNT_NAME" != "x" && "x$GLOBAL_ACCOUNT_NAME" == "x" ]]
  then
    echo
    echo "Warning: FULL_ACCOUNT_NAME has been deprecated. Please use GLOBAL_ACCOUNT_NAME instead."
    echo
  fi

}

main
