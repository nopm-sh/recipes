#!/bin/bash

# nopm:subst VERSION type:version

set -e

os=$(uname -s | tr "[:upper:]" "[:lower:]")
arch=$(uname -m)

case "$arch" in
"x86_64")
    arch="amd64"
    ;;
"i686" | "i")
    arch="i385"
    ;;
*)
    echo "Incompatible architecture $arch"
    exit 2
    ;;
esac

version=""

if [ -z $version ]
then
  base_url=https://dl.google.com/go/go
  download_page=$(mktemp /tmp/nopm.sh-recipe-go.XXXXXX)
  trap 'rm -f -- "$DOWNLOAD_PAGE"' EXIT
  wget --quiet https://golang.org/dl/ -O $download_page
  download_url=$(cat $download_page | grep "$base_url[[:digit:]]\.[[:digit:]]\{1,2\}\.[[:digit:]]\{1,2\}.$os.$arch\.tar\.gz" | head -n1 | sed -e "s#.*href=\"##" -e "s/\".*//")
  version=$(echo $download_url | grep "$base_url[[:digit:]]\.[[:digit:]]\{1,2\}\.[[:digit:]]\{1,2\}.$os.$arch\." \
  | head -n1 \
  | sed "s#.*$base_url##" \
  | sed "s/\.$os.*//")

fi

wget --continue $download_url
tar -C /usr/local -xvzf go$version.$os-$arch.tar.gz

mkdir -p ~/go/{bin,pkg,src}

if [ -z $GOPATH ]
then
  echo "export GOPATH=~/go" >> ~/.profile && source ~/.profile
fi

if ! which go &>/dev/null
then
  echo "export PATH='$PATH':/usr/local/go/bin:$GOPATH/bin" >> ~/.profile && source ~/.profile
fi

go version
rm -f -- go$version.$os-$arch.tar.gz
