#!/bin/sh

# nopm:subst version
# nopm:tags devops hashicorp
# nopm:url https://terraform.io
# nopm:depends unzip

set -e

NOPMSH_URL=${NOPMSH_URL-https://nopm.sh}

detect_os() {
  uname -s | tr '[:upper:]' '[:lower:]'
}

detect_arch() {
  arch="$(uname -m | tr '[:upper:]' '[:lower:]')"

  if echo "${arch}" | grep -i arm >/dev/null; then
    # ARM is fine
    arch=arm
  else
    if [ "${arch}" = "386" ]; then
      arch=386
    elif [ "${arch}" = "x86_64" ]; then
      arch=amd64
    fi

    # `uname -m` in some cases mis-reports 32-bit OS as 64-bit, so double check
    if [ "${arch}" = "x64" ] && [ "$(getconf LONG_BIT)" -eq 32 ]; then
      arch=386
    fi

    echo "${arch}"
  fi
}

version=""
if test -z "$version"
then
  version=$(curl -sL "$NOPMSH_URL/_/providers/hashicorp/latest_version/terraform")
fi

arch=$(detect_arch)
os=$(detect_os)

search_download_url="$NOPMSH_URL/_/providers/hashicorp/release_url/terraform/${version}/${os}/${arch}"
release_url=$(curl "$search_download_url")
curl -fL "$release_url" -o "terraform_${version}_${os}_${arch}.zip"

unzip -o "terraform_${version}_${os}_${arch}.zip" terraform -d /usr/local/bin

rm -f "terraform_${version}_${os}_${arch}.zip"
