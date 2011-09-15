#!/bin/bash

# Always use the default properties file. Otherwise can't set variables in
# bash. $1 returns last variable BASH set
ENV_PROPERTIES="Build/etc/env.properties"

#
# Puts a property from $ENV_PROPERTIES into $property
#
# @param propertyName - name of the property to read from ENV_PROPERTIES
# @sets property - to the value of propertyName if it is found
#
function getEnvProperty {
    propertyName=$1
    property=`grep "^$propertyName[ ]*=" $ENV_PROPERTIES | cut -d "=" -f 2|tr -d '[:space:]'`
}

#
# Exports a given property (if it exists) from the $ENV_PROPERTIES file to a
# given env variable. If the property is not present and the default value is
# provided, the env variable is set to the default value
#
# @param propertyName - name of the custom property to read from ENV_PROPERTIES
# @param environmentVariable - name of the system environment variable to set
# @param defaultValue - default value to set environmentVariable to set if 
# propertyName is not found in ENV_PROPERTIES
#
function exportCustomProperty {
    propertyName=$1
    environmentVariable=$2
    defaultValue=$3
    getEnvProperty "$propertyName"
    # if propertyName was found in ENV_PROPERTIES
    if [ -n "$property" ]
    then
        eval "export $environmentVariable=$property"
    fi
    # if propertyName is set to nothing
    if [ "$property" == "" ]
    then
        echo "[Warning] $propertyName was not found in $ENV_PROPERTIES"
        if [ -n "$defaultValue" ]
        then
            eval "export $environmentVariable=$defaultValue"
            echo "          $environmentVariable has been set to the 
            default $defaultValue"
        fi
    fi
}

#
# Set Environment Variables from ENV_PROPERTIES
#
echo "Deriving property build.home from current working directory"
export BUILD_HOME=`pwd`"/Build"
export ANT_HOME="$BUILD_HOME/opt/apache-ant"
exportCustomProperty "java.home" JAVA_HOME "/app/unico/jdk"

#
# Prints the value of a given env variable
#
# @param the property name
# #
function printProp {
    eval "tmp=\$$1"
    echo "$1=$tmp"
}

#
# Echo set properties to screen
#
echo
echo "Environment set as:"

printProp ANT_HOME
printProp BUILD_HOME
printProp JAVA_HOME

#
# Set Paths
#
export PATH=$ANT_HOME/bin:$JAVA_HOME/bin:$PATH
export ANT_CLASSPATH=$ANT_HOME/lib/ant.jar:$ANT_HOME/lib/ant-junit.jar:$BUILD_HOME/lib/junit/junit-4.8.2.jar:$BUILD_HOME/lib/antContrib/ant-contrib-1.0b3.jar:$BUILD_HOME/lib/sqlUnit/sqlunit-5.0.jar:$BUILD_HOME/lib/log4j/log4j-1.2.15.jar:$BUILD_HOME/lib/jdom/jdom-1.0.jar:$BUILD_HOME/lib/hsql/hsqldb-1.8.0.7.jar:$BUILD_HOME/lib/sqlite/sqlitejdbc-v056.jar:$ANT_HOME/lib

# set classpath
export CLASSPATH=$ANT_CLASSPATH

echo
echo Environment initialised

cd $BUILD_HOME
