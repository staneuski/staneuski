# zsh specific settings

include $HOME/.profile
include $HOME/.zsh_powerline


# ----- exports -----------------------
HISTSIZE=1000000
SAVEHIST=1000000
HISTORY_IGNORE="l|la|lra|lr|ll|ls|[bf]g|exit|pwd|clear|of\ [0-9]"


# ----- bindkeys ----------------------
bindkey "^R" history-incremental-search-backward
bindkey "\e[A" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward


# ----- setopt ------------------------
setopt INC_APPEND_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
