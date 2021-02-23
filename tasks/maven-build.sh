#!/bin/bash

# input folders:
# version : contains a file called number with the current version
# source-code : contains the source code

# output folders:
# build: contains the built jar

set -e

source ./pipeline/tasks/common.sh

VERSION=$(build_version "./version" "number" "./source-code" $BRANCH)
echo "Version to build: ${VERSION}"

echo "Generating maven settings.xml"
./pipeline/tasks/generate-settings.sh

cd source-code

echo "Setting maven with version to build"
mvn versions:set -DnewVersion=${VERSION}

echo "Building artifact ..."
mvn deploy ${MAVEN_ARGS} -DaltDeploymentRepository=repo::default::file:../build

echo "Copying artifact to ./build "
cp target/*.jar ../build
ls -lR ../build
