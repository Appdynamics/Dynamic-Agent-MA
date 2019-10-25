#!/bin/bash

main() {

  if [ ! -f controller.env ]
  then

    echo "You must include a controller.env file"

  else

    docker pull appdynamics/dynamic-agent-ma:1.3.2
    docker tag appdynamics/dynamic-agent-ma:1.3.2 machine-agent

    export $(cat controller.env | xargs)

    if [[ "x$CONTROLLER_HOST" == "x" || "x$CONTROLLER_PORT" == "x" || "x$CONTROLLER_SSL_ENABLED" == "x" || "x$APPLICATION_NAME" == "x" || "x$ACCOUNT_ACCESS_KEY" == "x" ]]; then

      echo "CONTROLLER_HOST, CONTROLLER_PORT, CONTROLLER_SSL_ENABLED, APPLICATION_NAME, ACCOUNT_NAME, and ACCOUNT_ACCESS_KEY are required"

    else

      deprecatedParameterCheck

      VOLUME_MOUNT=""

      if [ -d agent-files ] && [ "$(ls -A agent-files)" ]
      then

        tar -cvf agent-files.tar agent-files

        VOLUME_MOUNT=" -v ${PWD}/agent-files.tar:/opt/machine-agent/monitors/dynamicAttach/agent-files.tar "

        if [ -f agent-files/cacerts.jks ]
        then

          VOLUME_MOUNT="${VOLUME_MOUNT} -v ${PWD}/agent-files/cacerts.jks:/opt/machine-agent/conf/cacerts.jks "

        fi

      fi

      HIERARCHY_PATH=`hostname`

      docker run -d --env-file=controller.env -e HIERARCHY_PATH=${HIERARCHY_PATH} $VOLUME_MOUNT --expose "9090" --dns="8.8.8.8" --volume=/:/hostroot:ro --volume "/var/run/docker.sock:/var/run/docker.sock" \
        --hostname machine-agent --name machine-agent machine-agent


      if [ -f agent-files.tar ]
      then

        rm agent-files.tar

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
