# vim:fileencoding=utf-8:foldmethod=marker

#: Environment {{{
#: Compiled software location
# export PREFIX=$HOME/.local

#: zsh dotfiles
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

#: History
export HISTSIZE=1000000
export HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh_history"
export HISTDUP=erase
export SAVEHIST="$HISTSIZE"
#: }}}

#: Functions {{{
function swap() {
  local lhs="${1}" rhs="${2}"

  local tmp=$(mktemp --dry-run ${lhs}.XXXXXX)
  mv "${lhs}" "${tmp}"
  mv "${rhs}" "${lhs}"
  mv "${tmp}" "${rhs}"
}

function lf() {
  if [ "$#" -eq 0 ]; then
    command lf
    return
  fi

  local args=("$@")
  local resolved=$(zoxide query --list "${args[-1]}" |head -1)
  [ -n "$resolved" ] && [ -d "$resolved" ] &&
    args[-1]="$resolved"
  command lf -log ${TMPDIR:-/tmp}/lf.log "${args[@]}"
}

function lf-zoxide-widget() {
  local dir="$(zoxide query --interactive)" ||
    return
  [ -n "$dir" ] && lf "$dir"
}
#: }}}
