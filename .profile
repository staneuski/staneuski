# vim:fileencoding=utf-8:foldmethod=marker
# Profile for bash and zsh

#: Functions {{{
function append_pathenv() {
  if [ -d $1 ]; then
    PATH="${PATH}:${1}"
  fi
}
function include() {
  if [ -f $1 ]; then
    source $1
  fi
}

# un - archive extractor
# usage: un <file>
function un() {
  if [ -f $1 ]; then
    case $1 in
      *.7z)        7z x $1      ;;
      *.bz2)       bunzip2 $1   ;;
      *.gz)        gunzip $1    ;;
      *.rar)       unrar x $1   ;;
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.tar.xz)    tar xJf $1   ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.txz)       tar xJf $1   ;;
      *.Z)         uncompress $1;;
      *.zip)       unzip $1     ;;
      *)           echo "'$1' cannot be extracted via un()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

function swap() {
  local tmp_file=/tmp/$$.tmp
  mv "${1}" $tmp_file && mv "${2}" "${1}" && mv $tmp_file "${2}"
}
#: }}}

#: Exports {{{
append_pathenv $HOME/.local/bin
export PATH

[[ $(uname) == "Linux" ]] && \
  export PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME}:${PWD}\007"' # set terminal tab title

# [[ -z ${TMPBOX+x} ]] && \
#   export TMPBOX=$(mktemp /tmp/$USER.XXXXXX)
#: }}}

#: Aliases {{{
alias :q="exit"
alias conf-git="/usr/bin/git --git-dir=${HOME}/.local/etc/conf-git --work-tree=${HOME}"

if [[ $(uname) == "Linux" ]]; then
  alias sudoenv="sudo env PATH=${PATH}"
fi

#: Confirm before overwrite
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

#: Colorize grep output
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

#: Aliases by availiable commands {{{
#: exa
if command -v exa > /dev/null; then
  alias exa="exa --color=always --group-directories-first"
  alias l.='exa --all | grep "^\."'
  alias la="exa --all"
  alias ld="exa --only-dirs"
  alias ll="exa --all --classify --long"
  alias ls="exa --classify"
  alias lv="exa --only-dirs --long"
  alias tree="exa --tree"
else
  if [[ $(uname) == "Linux" ]]; then
    alias ld="dir --color=auto"
    alias lv="vdir --color=auto"
  elif [[ $(uname) == "Darwin" ]]; then
    alias ls="ls -G"
  fi
  alias l.='ls -A -F | egrep "^\."'
  alias la="ls -A -F"
  alias ll="ls -alFh"
  alias lr="ls -ltrh"
  alias lra="ls -ltrha"
fi

#: kitty
if [[ $TERM == xterm-kitty ]]; then
  alias kssh="kitty +kitten ssh"
fi

#: slurm
if command -v squeue > /dev/null; then
  alias sq='squeue --format="%.8i %.9P %.42j %.8T %.6M %.4D %R" --me'
fi
#: }}}

include $HOME/.local/prefs.sh # source machine specific settings
