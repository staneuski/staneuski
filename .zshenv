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
function opt-load() {
  local prefix="$(realpath ${1})"
  [ -d "${prefix}" ] ||
    return

  [[ "${PATH}" =~ .*"${prefix}/bin".* ]] ||
    export PATH="${prefix}/bin:${PATH}"
  [[ "${LD_LIBRARY_PATH}" =~ .*"${prefix}/lib".* ]] ||
    export LD_LIBRARY_PATH="${prefix}/lib:${LD_LIBRARY_PATH}"
  [[ "${MANPATH}" =~ .*"${prefix}/share/man".* ]] ||
    export MANPATH="${prefix}/share/man:${MANPATH}"
}

function opt-unload() {
  local prefix="$(realpath ${1})"
  [ -d "$prefix" ] ||
    return
               
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
#: }}}
