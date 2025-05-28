# vim:fileencoding=utf-8:foldmethod=marker
#$ ln -sfn env-stargate.sh $HOME/.config/zsh/.zprofile

export EDITOR='nvim -u ${HOME}/.vim/init.lua'
alias vi="${EDITOR}"

export RIP_GRAVEYARD="/noback/${USER}/.graveyard"
export _ZO_DOCTOR=0

export HOMEBREW_CURL_PATH="${HOME}/.local/bin/curl"
export HOMEBREW_GIT_PATH="${HOME}/.local/bin/git"
export HOMEBREW_PREFIX="${HOME}/.local/opt/linuxbrew"

# export SPACK_ROOT="/scratch/${USER}/opt/spack"

export PIPX_HOME="${HOME}/.local/opt/pipx"
export PYENV_ROOT="${HOME}/.local/opt/pyenv"
