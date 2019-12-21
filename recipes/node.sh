#!/bin/bash

# nopm:subst version
# nopm:url https://nodejs.org
# nopm:remote_script https://raw.githubusercontent.com/zeit/install-node/master/install.sh
# nopm:compat darwin@x86_64 linux@x86_64

set -e

version=""

REMOTE_SCRIPT=https://raw.githubusercontent.com/zeit/install-node/master/install.sh

if test "$INTERACTIVE" = "no"
then
    auto="--yes"
fi

if test -z $version
then
  curl -o- -L $REMOTE_SCRIPT | bash -s -- $auto
else
  curl -o- -L $REMOTE_SCRIPT | bash -s -- --version=$version $auto
fi
