# vim:fileencoding=utf-8:foldmethod=marker

#: Source global definitions
[ -f /etc/bashrc ] &&
  . /etc/bashrc
[ -f /opt/etc/profile ] &&
  . /opt/etc/profile 

#: Exports {{{
#: User specific environment
[[ "${PATH}" == *nix* ]] &&
  export PATH=$(echo $PATH | sed -E 's|/usr/local/bin:/usr/local/sbin:||; s|/usr/bin:|/usr/local/bin:/usr/local/sbin:/usr/bin:|')
[[ "${PATH}" =~ .*"${HOME}/.local/bin".* ]] ||
  export PATH="${HOME}/.local/bin:${PATH}"

[ -f "${HOME}/.env.sh" ] &&
  source "${HOME}/.env.sh"

[ -z ${BASH_COMPLETION_USER_DIR+x} ] &&
  export BASH_COMPLETION_USER_DIR="$HOME/.local/share/bash-completion"

[[ "${MANPATH}" =~ .*"${HOME}/.local/share/man".* ]] ||
  export MANPATH="${HOME}/.local/share/man:${MANPATH}"
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
if command -v eza > /dev/null; then
  alias ls='eza --color=always --group-directories-first' 
  alias la='eza --color=always --group-directories-first -la'
  alias ldot='eza --color=always --group-directories-first -ld .*'
  alias lD='eza --color=always --group-directories-first -lD'
  alias lDD='eza --color=always --group-directories-first -lDa'
  alias ll='eza --color=always --group-directories-first -l'
  alias lsd='eza --color=always --group-directories-first -d'
  alias lsdl='eza --color=always --group-directories-first -dl'
  alias lS='eza --color=always --group-directories-first -l -ssize'
  alias lT='eza --color=always --group-directories-first -l -snewest'
fi

#: ohmyzsh/plugins/kitty
if [ ${TERM} == 'xterm-kitty' ]; then
  alias kssh='kitty +kitten ssh'
  alias kssh-slow='infocmp -a xterm-kitty | ssh myserver tic -x -o \~/.terminfo /dev/stdin'
  alias kitty-theme='kitty +kitten themes'
fi

#: slurm
command -v squeue > /dev/null &&
  alias sq='squeue --format="%.8i %.9P %.42j %.8T %.6M %.4D %R" --me'

#: zoxide
command -v zoxide > /dev/null &&
  alias dq='zoxide query --list'
#: }}}

#: Integrations {{{
#: fzf
command -v fzf > /dev/null &&
  eval "$(fzf --bash)"

#: pyenv
if command -v pyenv > /dev/null && [ -z ${PYENV_ROOT+x} ]; then
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init - bash)"
  # eval "$(pyenv virtualenv-init -)"
fi

#: starship / prompt
if [[ ! $(uname -m) =~ ^mips.* ]]; then
  command -v starship > /dev/null &&
    eval "$(starship init bash)"
else
  export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\W\[\033[00m\]❯ '
fi

#: zoxide
command -v zoxide > /dev/null &&
  eval "$(zoxide init --cmd=cd bash)"
#: }}}
