# vim:fileencoding=utf-8:foldmethod=marker
# zsh specific settings

. $HOME/.profile
if command -v starship > /dev/null; then
  eval "$(starship init zsh)"
fi

#: Exports {{{
HISTSIZE=1000000
SAVEHIST=1000000
HISTORY_IGNORE="l|la|lra|lr|ll|ls|[bf]g|exit|pwd|clear"
#: }}}

#: Bindkeys {{{
bindkey "^R" history-incremental-search-backward
bindkey "\e[A" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward
#: }}}

#: Setopts {{{
setopt INC_APPEND_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
#: }}}
