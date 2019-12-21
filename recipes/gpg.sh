#!/bin/bash

# nopm:compat darwin@x86_64
# nopm:compat linux@x86_64

installed="gpg --version"

$installed
if test $? -gt 0
then
  set -e
  if test -f /etc/debian_version
  then
    apt-get update && apt-get -y install gpg
  else
    echo "Unknown OS: $(uname -a)"
    exit 1
  fi
fi
set -e
$installed
