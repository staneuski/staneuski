# vim:fileencoding=utf-8:foldmethod=marker
#: Environment {{{
#: zsh dotfiles
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

#: History
if [ -n "${BASH_VERSION-}" ]; then
  HISTFILE='bash'
elif [ -n "${ZSH_VERSION-}" ]; then
  HISTFILE='zsh'
else
  HISTFILE=''
fi
export HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/${HISTFILE}/history"
export HISTSIZE=1000000
export HISTDUP=erase
export SAVEHIST="${HISTSIZE}"
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

  [[ "${C_INCLUDE_PATH}" =~ .*"${prefix}/include".* ]] ||
    export C_INCLUDE_PATH="${prefix}/include:${C_INCLUDE_PATH}"
  [[ "${CPLUS_INCLUDE_PATH}" =~ .*"${prefix}/include".* ]] ||
    export CPLUS_INCLUDE_PATH="${prefix}/include:${CPUS_INCLUDE_PATH}"

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

  C_INCLUDE_PATH="${C_INCLUDE_PATH//:$prefix\/include/}"
  export C_INCLUDE_PATH="${C_INCLUDE_PATH/#$prefix\/include:/}"
  CPP_INCLUDE_PATH="${CPP_INCLUDE_PATH//:$prefix\/include/}"
  export CPP_INCLUDE_PATH="${CPP_INCLUDE_PATH/#$prefix\/include:/}"

  LD_LIBRARY_PATH="${LD_LIBRARY_PATH//:$prefix\/lib/}"
  export LD_LIBRARY_PATH="${LD_LIBRARY_PATH/#$prefix\/lib:/}"

  MANPATH="${MANPATH//:$prefix\/share\/man/}"
  export MANPATH="${MANPATH/#$prefix\/share\/man:/}"
}

function swap() {
  if [ $# -ne 2 ]; then
    echo "Usage: swap FILE1 FILE2"
    return 1
  fi
  local lhs="${1}" rhs="${2}"

  local tmp=$(mktemp --dry-run ${lhs}.XXXXXX)
  mv "${lhs}" "${tmp}"
  mv "${rhs}" "${lhs}"
  mv "${tmp}" "${rhs}"
}
#: }}}
