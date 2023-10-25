# vim:fileencoding=utf-8:foldmethod=marker
# bash specific settings

. $HOME/.config/profiles/_common.sh
if command -v starship > /dev/null; then
  eval "$(starship init bash)"
fi

#: enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

#: Exports {{{
export HISTCONTROL=ignoreboth:erasedups # don't put duplicate lines or lines starting with space in the history
export HISTIGNORE="&:l:la:lra:lr:ll:ls:[bf]g:exit:pwd:clear"
export HISTFILESIZE=1000000
export HISTSIZE=1000000
#: }}}

#: Shopts {{{
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
#: }}}

