# vim:fileencoding=utf-8:foldmethod=marker

#: Source global definitions
[ -f /etc/bashrc ] &&
  . /etc/bashrc

#: Exports {{{
#: User specific environment
[[ "${PATH}" =~ .*"${HOME}/.local/bin".* ]] ||
  export PATH="${HOME}/.local/bin:${PATH}"
#: }}}

#: Functions {{{
function swap() {
  local tmp_file=/tmp/$$.tmp
  mv "${1}" $tmp_file && mv "${2}" "${1}" && mv $tmp_file "${2}"
}
#: }}}

#: Aliases {{{
# BEGIN_ASHELL_PROFILE
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
alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS}'
alias ff='find . -type f -name'
# END_ASHELL_PROFILE
command -v fd > /dev/null &&
  alias fd='find . -type d -name'

#: ohmyzsh/plugins/eza
if command -v exa > /dev/null; then
  alias ls='exa --color=always --group-directories-first' 
  alias la='exa --color=always --group-directories-first -la'
  alias ldot='exa --color=always --group-directories-first -ld .*'
  alias lD='exa --color=always --group-directories-first -lD'
  alias lDD='exa --color=always --group-directories-first -lDa'
  alias ll='exa --color=always --group-directories-first -l'
  alias lsd='exa --color=always --group-directories-first -d'
  alias lsdl='exa --color=always --group-directories-first -dl'
  alias lS='exa --color=always --group-directories-first -l -ssize'
  alias lT='exa --color=always --group-directories-first -l -snewest'
fi

#: ohmyzsh/plugins/kitty
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
#: Machine specific environment
[ -f ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zlogin ] &&
  source ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zlogin

#: Programms {{{
#: fzf
command -v fzf > /dev/null &&
  eval "$(fzf --bash)"

if [[ ! $(arch) =~ ^mips.* ]]; then
  #: starship
  command -v starship > /dev/null &&
    eval "$(starship init bash)"
fi
#: }}}
