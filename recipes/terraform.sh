#!/bin/sh

# nopm:tags devops hashicorp

latest=$(curl -sL nopm.sh/github.com/hashicorp/releases/latest)

echo "$latest"
