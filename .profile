# Profile for bash and zsh

# ----- functions ---------------------
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

# ----- exports -----------------------
append_pathenv $HOME/.bin
append_pathenv $HOME/.local/bin

[[ $(uname) == "Linux" ]] && \
export PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME}:${PWD}\007"' # set terminal tab title

export PATH


# ----- aliases -----------------------
alias :q="exit"
alias conf-git="/usr/bin/git --git-dir=${HOME}/.local/etc/conf-git --work-tree=${HOME}"
alias cp="cp -i"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"
alias grep="grep --color=auto"
alias l="ls -Ca"
alias la="ls -A -F"
alias ll="ls -alFh"
alias lr="ls -ltrh"
alias lra="ls -ltrha"
alias np="nano PKGBUILD"
alias rm="rm -i"

if [[ $TERM == xterm-kitty ]]; then
  alias ssh="kitty +kitten ssh"
fi

if [[ $(uname) == "Linux" ]]; then
  alias bat="bat --style='grid,numbers,header'"
  alias dir="dir --color=auto"
  alias sq='squeue --format="%.8i %.9P %.42j %.8T %.6M %.4D %R" --me'
  alias sudoenv="sudo env PATH=${PATH}"
  alias vdir="vdir --color=auto"

elif [[ $(uname) == "Darwin" ]]; then
  alias bat="bat --theme=\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo default || echo GitHub)"
  alias ls="ls -G"
  alias rsync="rsync --exclude=.DS_Store"
  alias mdls-pdf="mdls -name kMDItemTitle \
                       -name kMDItemAuthors \
                       -name kMDItemDescription \
                       -name kMDItemCreator \
                       -name kMDItemKeywords"
fi

include $HOME/.local/prefs.sh # source machine specific settings
