# vim:fileencoding=utf-8:foldmethod=marker
# t21202-lr017 machine (Aalto Linux) specific settings

include /l/GTI/gtenv.sh

#: Functions {{{
function of () {
  if [ -f /opt/openfoam$1/etc/bashrc ] && [ -z ${2+x} ]; then
    . /opt/openfoam$1/etc/bashrc
  elif [ -f /usr/lib/openfoam/openfoam$1/etc/bashrc ] && [ -z ${2+x} ]; then
    /usr/bin/openfoam$1
  elif [ -f $HOME/.local/opt/OpenFOAM-$1/etc/bashrc ]; then
    . $HOME/.local/opt/OpenFOAM-$1/etc/bashrc
    WM_COMPILE_OPTION=$2
  else
    echo OpenFOAM-$1 was not found.
    return 1
  fi

  foamSetUserBins
  unset foamSetUsetBins

  [[ -r $WM_PROJECT_DIR/.build ]] && v=$(cat $WM_PROJECT_DIR/.build) || v=$1
  echo OpenFOAM@$v:$WM_PROJECT_DIR $WM_COMPILE_OPTION
}

#: Exports {{{
export WRKDIR=/m/work/t212/unix/work/$USER
#: }}}
