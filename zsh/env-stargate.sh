# vim:fileencoding=utf-8:foldmethod=marker
#$ ln -sfn env-stargate.sh $HOME/.config/zsh/.zprofile

export RIP_GRAVEYARD="/noback/${USER}/.graveyard"
export _ZO_DOCTOR=0

export HOMEBREW_CURL_PATH="${HOME}/.local/bin/curl"
export HOMEBREW_GIT_PATH="${HOME}/.local/bin/git"
export HOMEBREW_PREFIX="${HOME}/.local/opt/linuxbrew"

# export SPACK_ROOT="${HOME}/.local/opt/spack"

export NVM_DIR="${HOME}/.local/opt/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
