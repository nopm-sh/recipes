#!/bin/bash

# nopm:subst version
# nopm:url https://golang.org
# nopm:compat darwin x86_64
# nopm:compat linux x86_64

set -e

os=$(uname -s | tr "[:upper:]" "[:lower:]")
arch=$(uname -m)

case "$arch" in
"x86_64")
    arch="amd64"
    ;;
"i686" | "i")
    arch="i386"
    ;;
*)
    echo "Incompatible architecture $arch"
    exit 2
    ;;
esac

version=""
base_url=https://dl.google.com/go/go

if [ -z $version ]
then
  download_page=$(mktemp /tmp/nopm.sh-recipe-go.XXXXXX)
  trap 'rm -f -- "$DOWNLOAD_PAGE"' EXIT
  curl -s https://golang.org/dl/ > $download_page
  download_url=$(cat $download_page | grep "$base_url[[:digit:]]\.[[:digit:]]\{1,2\}\.[[:digit:]]\{1,2\}.$os-$arch\.tar\.gz" | head -n1 | sed -e "s#.*href=\"##" -e "s/\".*//")
  version=$(echo $download_url | grep "$base_url[[:digit:]]\.[[:digit:]]\{1,2\}\.[[:digit:]]\{1,2\}.$os-$arch\." \
  | head -n1 \
  | sed "s#.*$base_url##" \
  | sed "s/\.$os.*//")
else
  download_url="$base_url$version.$os-$arch.tar.gz"
fi

curl -s $download_url > go$version.$os-$arch.tar.gz
tar -C /usr/local -xvzf go$version.$os-$arch.tar.gz

mkdir -p ~/go/{bin,pkg,src}

if [ -z $GOPATH ]
then
  echo "export GOPATH=\$HOME/go" >> ~/.profile && . ~/.profile
fi

if ! which go &>/dev/null
then
  echo "export PATH='$PATH':/usr/local/go/bin:$GOPATH/bin" >> ~/.profile && . ~/.profile
fi

go version
rm -f -- go$version.$os-$arch.tar.gz
