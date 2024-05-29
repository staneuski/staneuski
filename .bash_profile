# vim:fileencoding=utf-8:foldmethod=marker
[ -f ~/.bashrc ] &&
  . ~/.bashrc

#: Environment {{{
#: History
export HISTCONTROL=ignoreboth:erasedups # don't put duplicate lines or lines starting with space in the history
export HISTIGNORE='&:l:la:lra:lr:ll:ls:bf:fg:exit:pwd:clear'
export HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/bash_history"
export HISTSIZE=10000
export HISTFILESIZE=2000000
shopt -s cmdhist # save multi-line commands in history as single line
shopt -s histappend # append to the history file, don't overwrite it

#: Terminal tab name
[ $(uname) = Linux ] &&
  export PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME}:${PWD}\007"'

#: Autocomplete
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

#: etc.
shopt -s cdspell # autocorrect cd misspellings
shopt -s checkwinsize # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
shopt -s hostcomplete
shopt -s nocaseglob
shopt -u progcomp
#: }}}

#: Startup programs {{{
#: Enable ls color support
[ -x /usr/bin/dircolors ] &&
  eval "$(dircolors -b)"
#: }}}
