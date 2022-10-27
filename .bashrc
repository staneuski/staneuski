# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

if [ -f $HOME/.profile ]; then
  . $HOME/.profile
fi

if [ -f $HOME/.bash_powerline ]; then
  . $HOME/.bash_powerline
fi

shopt -s cdspell
shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
shopt -s hostcomplete
shopt -s nocaseglob
shopt -u progcomp

export HISTSIZE=1000000
export HISTFILESIZE=1000000
export HISTIGNORE="&:l:la:lra:lr:ll:ls:[bf]g:exit:pwd:clear:of\ [0-9]"

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# multi-line commands are stored in the history as a single command
shopt -s cmdhist

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
