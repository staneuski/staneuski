# vim:fileencoding=utf-8:foldmethod=marker
# t21202-lr017 machine (Aalto Linux) specific settings

#: Exports {{{
#: Directories
export WRKDIR=/m/work/t212/unix/work/$USER

#: GridPro
export GRIDPRO=/l/opt/GridPro
export PYTHONPATH=$GRIDPRO/lib:$PYTHONPATH
export PATH=${PATH}:$GRIDPRO/bin
export PATH=${PATH}:$GRIDPRO/lc_mngr

#: GT-Suite
include /l/GTI/gtenv.sh
#: }}}

#: Functions {{{
function of () {
  if [ -f /opt/openfoam$1/etc/bashrc ] && [ -z ${2+x} ]; then
    . /opt/openfoam$1/etc/bashrc
  elif [ -f /usr/lib/openfoam/openfoam$1/etc/bashrc ] && [ -z ${2+x} ]; then
    /usr/bin/openfoam$1
  elif [ -f $HOME/.local/opt/OpenFOAM-$1/etc/bashrc ]; then
    sed -i "
        s|WM_COMPILE_OPTION=Opt|WM_COMPILE_OPTION=${2}|g;
        s|WM_COMPILE_OPTION=Debug|WM_COMPILE_OPTION=${2}|g
    " $HOME/.OpenFOAM/prefs.sh

    module load common/triton-modules cmake gcc scotch flex > /dev/null
    . $HOME/.local/opt/OpenFOAM-$1/etc/bashrc

    sed -i "s|WM_COMPILE_OPTION=${2}|WM_COMPILE_OPTION=Opt|g
    " $HOME/.OpenFOAM/prefs.sh
  else
    echo OpenFOAM-$1 was not found.
    return 1
  fi

  [[ -r $WM_PROJECT_DIR/.build ]] && v=$(cat $WM_PROJECT_DIR/.build) || v=$1
  echo OpenFOAM@$v:$WM_PROJECT_DIR $WM_COMPILE_OPTION

  export FOAM_RUN=$HOME/Files/OpenFOAM
  export WM_PROJECT_SITE=${HOME}/Developer/Projects/froth
  export PATH=${PATH}:$PYTHONUSERBASE/bin
}
#: }}}

#: Aliases {{{
#: }}}
