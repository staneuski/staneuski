# Profile for both shells (as for bash and for zsh)

alias :q='exit'
# alias bat='bat --theme=GitHub'  # requires bat
alias conf-git='/usr/bin/git --git-dir=$HOME/.local/etc/conf-git --work-tree=$HOME'
alias cp='cp -i'
alias dir='dir --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l='ls -Ca'
alias la='ls -A -F'
alias ll='ls -alFh'
alias lr='ls -ltrh'
alias lra='ls -ltrha'
alias np='nano PKGBUILD'
alias rm='rm -i'
alias sudoenv='sudo env PATH=$PATH'
alias sq='squeue --format="%.8i %.9P %.42j %.8T %.6M %.4D %R" --me'
alias vdir='vdir --color=auto'

if [[ $TERM == xterm-kitty ]]; then
  alias ssh='kitty +kitten ssh'
fi

if [[ $(uname) == "Darwin" ]]; then
  alias ls='ls -G'
  alias rsync='rsync --exclude=.DS_Store'

  alias mdls-pdf='mdls -name kMDItemTitle \
                       -name kMDItemAuthors \
                       -name kMDItemDescription \
                       -name kMDItemCreator \
                       -name kMDItemKeywords'
  alias sstp-flat392='sudo /usr/local/sbin/sstpc flat392.keenetic.link \
                      --user=stas --password=9652918444 \
                      --log-level 4 --log-stderr --cert-warn --tls-ext \
                      usepeerdns require-mschap-v2 noauth noipdefault defaultroute refuse-eap noccp'
elif [[ $(uname) == "Linux" ]]; then
  alias ls='ls --group-directories-first --color=auto'
  alias open='xdg-open &>/dev/null'
  alias xsetkeyr='xset r rate 182 42'

  export PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME}:${PWD}\007"'

  export PATH="$PATH:$HOME/.local/bin"
fi

safeSource () {
  if [ -f $1 ]; then
    . $1
  fi
}

safeSource $HOME/.local/prefs.sh

# un - archive extractor
# usage: un <file>
un () {
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
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Move file or directory with creating a full path (if not exists)
# usage: mkmv <source> <target>
function mkmv () {
  dir="$2" # Include a / at the end to indicate directory (not filename)
  tmp="$2"; tmp="${tmp: -1}"
  [ "$tmp" != "/" ] && dir="$(dirname "$2")"
  [ -a "$dir" ] || mkdir -p "$dir" && mv "$@"
}

function truegrad () {
  # Published: https://github.com/termstandard/colors

  awk 'BEGIN{
    s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
    for (colnum = 0; colnum<77; colnum++) {
      r = 255-(colnum*255/76);
      g = (colnum*510/76);
      b = (colnum*255/76);
      if (g>255) g = 510-g;
      printf "\033[48;2;%d;%d;%dm", r,g,b;
      printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
      printf "%s\033[0m", substr(s,colnum+1,1);
    }
    printf "\n";
  }'
}

