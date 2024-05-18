export SHELL=$(which zsh)
[ -z "$ZSH_VERSION" ] &&
  exec /bin/zsh -l
