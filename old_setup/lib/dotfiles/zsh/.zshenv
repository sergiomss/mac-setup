export AWS_PROFILE="heimdall"
export NODE_PATH="/usr/local/lib/node_modules"
export GOPATH="$HOME/develop/go"
export GOROOT="$(brew --prefix golang)/libexec"
PATH+=":$GOPATH/bin:$GOROOT/bin:/usr/local/share/npm/bin:$HOME/.bin:$HOME/bin"
export PATH