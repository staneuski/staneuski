# vim:fileencoding=utf-8:foldmethod=marker
#$ ln -sfn env-darwin.sh $HOME/.config/zsh/.zprofile

[ $(uname -m) = 'arm64' ] &&
  export HOMEBREW_PREFIX="/opt/homebrew" ||
  export HOMEBREW_PREFIX="/usr/local"
