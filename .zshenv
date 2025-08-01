# vim:fileencoding=utf-8:foldmethod=marker

#: Environment {{{
#: zsh dotfiles
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

#: History
export HISTSIZE=1000000
export HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh_history"
export HISTDUP=erase
export SAVEHIST="$HISTSIZE"
#: }}}

#: Functions {{{
function opt-load() {
  if [ $# -ne 1 ]; then
    echo "Usage: opt-load PREFIX $#"
    return 1
  fi
  [ -d "${1}" ] ||
    return 1
  local prefix="$(realpath ${1})"

  [[ "${PATH}" =~ .*"${prefix}/bin".* ]] ||
    export PATH="${prefix}/bin:${PATH}"
  [[ "${LD_LIBRARY_PATH}" =~ .*"${prefix}/lib".* ]] ||
    export LD_LIBRARY_PATH="${prefix}/lib:${LD_LIBRARY_PATH}"
  [[ "${MANPATH}" =~ .*"${prefix}/share/man".* ]] ||
    export MANPATH="${prefix}/share/man:${MANPATH}"
}

function opt-unload() {
  if [ $# -ne 1 ]; then
    echo "Usage: opt-unload PREFIX"
    return 1
  fi
  [ -d "${1}" ] ||
    return 1
  local prefix="$(realpath ${1})"

  PATH="${PATH//:$prefix\/bin/}"
  export PATH="${PATH/#$prefix\/bin:/}"

  LD_LIBRARY_PATH="${LD_LIBRARY_PATH//:$prefix\/lib/}"
  export LD_LIBRARY_PATH="${LD_LIBRARY_PATH/#$prefix\/lib:/}"

  MANPATH="${MANPATH//:$prefix\/share\/man/}"
  export MANPATH="${MANPATH/#$prefix\/share\/man:/}"
}

function swap() {
  local lhs="${1}" rhs="${2}"

  local tmp=$(mktemp --dry-run ${lhs}.XXXXXX)
  mv "${lhs}" "${tmp}"
  mv "${rhs}" "${lhs}"
  mv "${tmp}" "${rhs}"
}

function lf() {
  local dir="$(command zoxide query --list "$@" | head -1)"

  command lf -log "${TMPDIR:-/tmp}/lf.log" "${dir:-$@}"
}

function lf-zoxide-widget() {
  local dir="$(command zoxide query --interactive)" || return
  [ -n "${dir}" ] && command lf -log "${TMPDIR:-/tmp}/lf.log" "${dir}"
}

#: }}}

if [ -e /u/42/stashes1/unix/.nix-profile/etc/profile.d/nix.sh ]; then . /u/42/stashes1/unix/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
