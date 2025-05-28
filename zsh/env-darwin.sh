# vim:fileencoding=utf-8:foldmethod=marker
#$ ln -sfn env-darwin.sh $HOME/.config/zsh/.zprofile

[ $(uname -m) = 'arm64' ] &&
  export HOMEBREW_PREFIX="/opt/homebrew" ||
  export HOMEBREW_PREFIX="/usr/local"

export PIPX_HOME="${HOME}/.local/share/pipx"
export VENV_HOME="${HOME}/.local/share/venv"
