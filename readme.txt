
Update the controller.env with the relevant connection information for your controller, then run the run.sh script.


controller.env Parameter Reference

All parameters:

CONTROLLER_HOST
CONTROLLER_PORT
CONTROLLER_SSL_ENABLED
ACCOUNT_NAME
ACCOUNT_ACCESS_KEY
APPLICATION_NAME
APPLICATION_NAME_FROM
APPLICATION_NAME_FROM_VALUE
EVENT_SERVICE_URL
GLOBAL_ACCOUNT_NAME
TIER_NAME_FROM
TIER_NAME_FROM_VALUE
INCLUDE_FILTER
EXCLUDE_FILTER
UNIQUE_HOST_ID
DEBUG_LOGGING
MA_PROPERTIES
JAVA_AGENT_PROPERITES

Required Parameters
 
CONTROLLER_HOST
Notes: Should not include http/https or port number
Example: CONTROLLER_HOST=appd.mydomain.com
 
CONTROLLER_PORT
Notes: Port number of controller
Example: CONTROLLER_PORT=8090
 
CONTROLLER_SSL_ENABLED=false
Possible values: Either true or false
Example: CONTROLLER_SSL_ENABLED=false
 
ACCOUNT_NAME
Notes: Name value found on License page of controller
Example: ACCOUNT_NAME=customer1
 
ACCOUNT_ACCESS_KEY
Notes: Access Key value found on License page of controller
Example: ACCOUNT_ACCESS_KEY=a5f426acdff0

APPLICATION_NAME
Notes: Do not use spaces in the Application Name
Example: APPLICATION_NAME=MyApp
 

Optional Parameters

MA_PROPERTIES
Used to add extra run-time parameters to the machine agent
Examples:
MA_PROPERTIES=-Dappdynamics.docker.container.containerIdAsHostId.enabled=true
This will cause the Machine Agent to run with that parameter added to the runtime parameters

JAVA_AGENT_PROPERITES
Used to add extra run-time parameters to the Java agent
Examples:
JAVA_AGENT_PROPERITES=-Dappdynamics.agent.ssl.protocol=TLSv1.2
This will cause the Java Agent to run with that parameter added to the runtime parameters
Note: Adding properties not related to the Java Agent, such as -Xmx2G, will have no effect on the JVM

DEBUG_LOGGING
When set to true, it will add extra logging to the machine agent logging output.

APPLICATION_NAME_FROM
Notes: If a match can be found from APPLICATION_NAME_FROM + APPLICATION_NAME_FROM_VALUE, 
the match will be used for the Application Name of that container. Otherwise, it will use the value from APPLICATION_NAME
Possible values: CONTAINER_LABEL, JVM_PARAM, or CONTAINER_NAME_REGEX

APPLICATION_NAME_FROM_VALUE
Notes: Used with APPLICATION_NAME_FROM. If using CONTAINER_NAME_REGEX, do not include escape characters, spaces, or add quotes around the regex
Examples: 
APPLICATION_NAME_FROM=CONTAINER_NAME_REGEX
APPLICATION_NAME_FROM_VALUE=.(.*_.*?)_

APPLICATION_NAME_FROM=JVM_PARAM
APPLICATION_NAME_FROM_VALUE=Dapplication-name

TIER_NAME_FROM
Notes: See section below - What is a tier? Also, if using CONTAINER_NAME_REGEX, do not include escape characters, spaces, or add quotes around the regex
Possible values: HOSTNAME, CONTAINER_NAME, CONTAINER_LABEL, JVM_PARAM, or CONTAINER_NAME_REGEX
Example: TIER_NAME_FROM=CONTAINER_NAME
 
TIER_NAME_FROM_VALUE
Notes: See section below - What is a tier?
Example: TIER_NAME_FROM_VALUE=DAPPD_TIER_NAME

EVENT_SERVICE_URL and GLOBAL_ACCOUNT_NAME are both necessary to enable analytics reporting from the instrumented containers
 
EVENT_SERVICE_URL
Notes: The host and port of of the Events Service this application should report to.
       Should not include http/https, but it should include the port
Example: EVENT_SERVICE_URL=appd.mydomain.com:9080
 
GLOBAL_ACCOUNT_NAME
Notes: Global Account Name value found on License page of controller
Example: GLOBAL_ACCOUNT_NAME=customer1_32458762934
 
What is a tier?

By default, the Hostname of the container will be used as the tier name in AppDynamics. If you want to change this, there are some optional parameters you can set in the controller.env file.

TIER_NAME_FROM

TIER_NAME_FROM=HOSTNAME or if left blank or not included in controller.env, it will use the hostname for the tier 
TIER_NAME_FROM=CONTAINER_NAME will cause the process to use the name of the container for the tier name
TIER_NAME_FROM=CONTAINER_LABEL will cause the process to use the value of the container label specified in TIER_NAME_FROM_VALUE
TIER_NAME_FROM=JVM_PARAM will cause the process to look for the JVM param specified in TIER_NAME_FROM_VALUE 
For example, the following controller.env file will result in the process looking for a JVM parameter -Dservice-name, and using that value for the tier name in AppDynamics.

CONTROLLER_HOST=my.controller.com
CONTROLLER_PORT=8090
CONTROLLER_SSL_ENABLED=false
APPLICATION_NAME=Jetty
ACCOUNT_NAME=customer1
ACCOUNT_ACCESS_KEY=4e76-a7f8-a5f426acdff0
TIER_NAME_FROM=JVM_PARAM
TIER_NAME_FROM_VALUE=Dservice-name


Filtering Processes
There are two more optional parameters for the controller.env file that you can use to customize which processes are included or excluded. They both use regular expressions that will be applied to process command strings.

INCLUDE_FILTER

This will be used to identify which processes to attach to. If no value is provided, the process will only look for "java" in the process command string.

EXCLUDE_FILTER

If you know of certain processes that you definitely don't want to instrument, you can provide a regular expression here to filter them out. For example, if no EXCLUDE_FILTER is provided, the process will exclude any Java processes that contain "Dappdynamics" in the command string. This will prevent any already-instrumented processes, such as the machine agent, from getting processed.

CONTAINER_NAME_WHITELIST
Notes: Comma-delimited list. If populated, only containers whose name is a substring match of one of the entries will be instrumented. 
Example: CONTAINER_NAME_WHITELIST=myapp1,myapp2

To enable proxy integration, the following values are exposed:
PROXY_HOST
PROXY_PORT
PROXY_USER

LABEL_FILTER_INCLUDE
Notes: If populated, the Dynamic Agent will only instrument containers matching one of the label names and values. Can be used in conjunction with the LABEL_FILTER_EXCLUDE setting.
Example: LABEL_FILTER_INCLUDE=com.example.label1=jetty1,jetty2;com.example.label2=jetty2,jetty3;

LABEL_FILTER_EXCLUDE
Notes: If populated, the Dynamic Agent will NOT instrument containers matching one of the label names and values. Can be used in conjunction with the LABEL_FILTER_INCLUDE setting.
Example: LABEL_FILTER_EXCLUDE=com.example.label1=jetty1,jetty2;com.example.label2=jetty2,jetty3;

UNIQUE_HOST_ID
Notes: If populated, the supplied value will be used as the UNIQUE_HOST_ID instead of the machine-derived UNIQUE_HOST_ID.


Customizing files in the AppServerAgent directory

If you would like custom files to be pushed to the agent conf directory, create a new directory called agent-files, and put your new files in this directory. The agent-files directory should reside in the same directory as the run.sh file.

The Dynamic Agent will then copy any file in agent-files into the Java Agent conf directory of any containers instrumented dynamically after this point.

Note, it will not affect any containers already instrumented or containers manually instumented.
