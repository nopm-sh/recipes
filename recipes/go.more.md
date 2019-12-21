Recipe persists required environment variables in your shell to run go binaries:

```
echo "export GOPATH=\$HOME/go" >> ~/.profile && . ~/.profile
echo "export PATH=\$PATH:/usr/local/go/bin:\$GOPATH/bin" >> ~/.profile && . ~/.profile
```

Please now run to reload your environment:

```
. ~/.profile
```
