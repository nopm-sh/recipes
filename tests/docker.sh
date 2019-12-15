#!/bin/bash

set -x

SCRIPT_DIR=$(dirname "$PWD/$0")

function debian {
  docker run -it -v $SCRIPT_DIR/../:/recipes debian /bin/sh -c " \
    apt-get update \
    && apt-get install -y curl \
    && . recipes/$recipe.sh \
    && go version"
}

function centos {
  docker run -it -v $SCRIPT_DIR/../:/recipes centos /bin/sh -c " \
    . recipes/$recipe.sh \
    && go version"
}

recipe=$1
if [ ! -f $SCRIPT_DIR/../$recipe.sh ]
then
  echo "No such recipe $recipe"
  exit 1
fi

debian
centos
