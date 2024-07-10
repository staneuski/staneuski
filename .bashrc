# vim:fileencoding=utf-8:foldmethod=marker

#: Source global definitions
[ -f /etc/bashrc ] &&
  . /etc/bashrc

#: Exports {{{
#: User specific environment
[[ "${PATH}" =~ "${HOME}/.local/bin:${HOME}/bin:" ]] ||
  export PATH="${HOME}/.local/bin:${PATH}"
#: }}}

#: Functions {{{
function swap() {
  local tmp_file=/tmp/$$.tmp
  mv "${1}" $tmp_file && mv "${2}" "${1}" && mv $tmp_file "${2}"
}
#: }}}

#: Aliases {{{
#: ohmyzsh/plugins/common-aliases#ls-command
alias l='ls -lFh'
alias la='ls -lAFh'
alias lr='ls -tRFh'
alias lt='ls -ltFh'
alias ll='ls -l'
alias ldot='ls -ld .*'
alias lS='ls -1FSsh'
alias lart='ls -1Fcart'
alias lrt='ls -1Fcrt'
alias lsr='ls -lARFh'
alias lsn='ls -1'

#: ohmyzsh/plugins/common-aliases#file-handling
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias dud='du -d 1 -h'
alias duf='du -sh'
alias t='tail -f'

#: ohmyzsh/plugins/common-aliases#find-and-grep
command -v fd > /dev/null &&
  alias fd='find . -type d -name'
alias ff='find . -type f -name'
alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS}'

#: ohmyzsh/plugins/common-aliases#kitty
if [ ${TERM} == 'xterm-kitty' ]; then
  alias kssh='kitty +kitten ssh'
  alias kssh-slow='infocmp -a xterm-kitty | ssh myserver tic -x -o \~/.terminfo /dev/stdin'
  alias kitty-theme='kitty +kitten themes'
fi

#: https://www.atlassian.com/git/tutorials/dotfiles
alias stow-git="/usr/bin/git --git-dir=${HOME}/.local/share/dotfiles --work-tree=${HOME}"

#: slurm
command -v squeue > /dev/null &&
  alias sq='squeue --format="%.8i %.9P %.42j %.8T %.6M %.4D %R" --me'
#: }}}

#: Integrations {{{
#: Programms {{{
if [[ ! $(arch) =~ ^mips.* ]]; then
  #: atuin
  [ -d "${HOME}/.atuin/" ] ||
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
  . "${HOME}/.atuin/bin/env"
  eval "$(atuin init bash)"

  #: starship
  command -v starship > /dev/null ||
    curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir "${HOME}/.local/bin" --force
  eval "$(starship init zsh)"
fi

#: Machine specific environment
[ -f ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zlogin ] &&
  source ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zlogin
#: }}}
