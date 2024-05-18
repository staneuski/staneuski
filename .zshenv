# vim:fileencoding=utf-8:foldmethod=marker

#: Shell {{{
#: zsh dotfiles
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

#: History
export HISTSIZE=1000000
export HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh_history"
export HISTDUP=erase
export SAVEHIST="$HISTSIZE"
#: }}}

#: Package manager {{{
[ -f "/usr/local/bin/brew" ] &&
  eval "$(/usr/local/bin/brew shellenv)"
[ -f "/opt/homebrew/bin/brew" ] &&
  eval "$(/opt/homebrew/bin/brew shellenv)"
#: }}}

#: Editor, viewer, etc. {{{
export EDITOR=$(which vim)
#: }}}
