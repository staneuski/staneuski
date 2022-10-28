# bash specific settings

. $HOME/.profile
include $HOME/.bash_powerline

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi


# ----- exports -----------------------
export HISTCONTROL=ignoreboth:erasedups # don't put duplicate lines or lines starting with space in the history.
export HISTFILESIZE=1000000
export HISTIGNORE="&:l:la:lra:lr:ll:ls:[bf]g:exit:pwd:clear"
export HISTSIZE=1000000


# ----- shopts ------------------------
shopt -s cdspell # autocorrect cd misspellings
shopt -s checkwinsize # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s cmdhist # save multi-line commands in history as single line
shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
shopt -s histappend # append to the history file, don't overwrite it
shopt -s hostcomplete
shopt -s nocaseglob
shopt -u progcomp
