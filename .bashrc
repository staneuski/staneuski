# vim:fileencoding=utf-8:foldmethod=marker

#: Source global definitions
[ -f /etc/bashrc ] &&
  . /etc/bashrc

#: Exports {{{
#: User specific environment
[[ "${PATH}" =~ "${HOME}/.local/bin:${HOME}/bin:" ]] ||
  export PATH="${PATH}:${HOME}/.local/bin"

#: Prompt
command -v starship > /dev/null &&
  eval "$(starship init bash)"
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

#: slurm
command -v squeue > /dev/null &&
  alias sq='squeue --format="%.8i %.9P %.42j %.8T %.6M %.4D %R" --me'

#: https://www.atlassian.com/git/tutorials/dotfiles
alias stow-git="/usr/bin/git --git-dir=${HOME}/.local/share/dotfiles --work-tree=${HOME}"

#: kitty
[ ${TERM} == xterm-kitty ] &&
  alias kssh='kitty +kitten ssh'
#: }}}

#: Functions {{{
function swap() {
  local tmp_file=/tmp/$$.tmp
  mv "${1}" $tmp_file && mv "${2}" "${1}" && mv $tmp_file "${2}"
}
#: }}}

[ -f ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zlogin ] &&
  . ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zlogin 
