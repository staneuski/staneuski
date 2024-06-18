# vim:fileencoding=utf-8:foldmethod=marker
export PATH="${PATH}:${HOME}/.local/bin"

#: Environment {{{
#: Plugin manager (zinit)
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [ ! -d "${ZINIT_HOME}" ]; then
  mkdir -p "$(dirname ${ZINIT_HOME})"
  git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"
fi
source "${ZINIT_HOME}/zinit.zsh"

#: Prompt (starship)
command -v starship > /dev/null ||
  curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir "${HOME}/.local/bin" --force
eval "$(starship init zsh)"

#: Terminal tab
[[ $(uname) == "Linux" ]] &&
  export PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME}:${PWD}\007"'
#: }}}

#: Plugins {{{
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
#: }}}

#: Intergrations {{{
#: History settings
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

#: Completions
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

#: Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q
#: }}}

#: Aliases {{{
zinit snippet OMZP::common-aliases
zinit snippet OMZP::command-not-found

#: https://www.atlassian.com/git/tutorials/dotfiles
alias stow-git="/usr/bin/git --git-dir=${HOME}/.local/share/dotfiles --work-tree=${HOME}"

#: kitty
[ $TERM = xterm-kitty ] &&
  alias kssh="kitty +kitten ssh"
#: }}}

# Keybindings {{{
bindkey -e
# bindkey "^R" history-incremental-search-backward
bindkey "\e[A" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward
bindkey '^[w' kill-region
bindkey '^[[3~' delete-char
#: }}}

