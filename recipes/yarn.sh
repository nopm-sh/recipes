#!/bin/bash

# nopm:subst version
# nopm:url https://yarnpkg.com
# nopm:remote_script https://raw.githubusercontent.com/yarnpkg/website/master/install.sh
# nopm:compat darwin@x86_64
# nopm:compat linux@x86_64
# nopm:depends node
# nopm:depends gpg

set -e

version=""

REMOTE_SCRIPT=https://raw.githubusercontent.com/yarnpkg/website/master/install.sh

if test -z $version
then
  curl $REMOTE_SCRIPT -o- -L | bash -s --
else
  curl $REMOTE_SCRIPT -o- -L | bash -s -- --version [$version]
fi
