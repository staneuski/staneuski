# vim:fileencoding=utf-8:foldmethod=marker
# Maari computers (Aalto Linux) specific settings

#: Functions {{{
function of () {
  if [ $1 == "1906" ] && [ -z ${2+x} ]; then
    module load triton-modules/1.0 openfoam/$1-openmpi-metis
  elif [ -f /opt/openfoam$1/etc/bashrc ] && [ -z ${2+x} ]; then
    . /opt/openfoam$1/etc/bashrc
  elif [ -f $HOME/.local/opt/OpenFOAM-$1/etc/bashrc ]; then
    sed -i "
        s|WM_COMPILE_OPTION=Opt|WM_COMPILE_OPTION=${2}|g;
        s|WM_COMPILE_OPTION=Debug|WM_COMPILE_OPTION=${2}|g
    " $HOME/.OpenFOAM/prefs.sh
    
    . $HOME/.local/opt/OpenFOAM-$1/etc/bashrc

    sed -i "s|WM_COMPILE_OPTION=${2}|WM_COMPILE_OPTION=Opt|g
    " $HOME/.OpenFOAM/prefs.sh
  else
    echo OpenFOAM-$1 was not found.
    return 1
  fi

  export FOAM_USER_APPBIN=$HOME/.local/opt/$WM_PROJECT-$WM_PROJECT_VERSION/platforms/$WM_OPTIONS/bin
  export FOAM_USER_LIBBIN=$HOME/.local/opt/$WM_PROJECT-$WM_PROJECT_VERSION/platforms/$WM_OPTIONS/lib

  [[ -r $WM_PROJECT_DIR/.build ]] && v=$(cat $WM_PROJECT_DIR/.build) || v=$1
  echo OpenFOAM@$v:$WM_PROJECT_DIR
}
#: }}}

#: Exports {{{
export WRKDIR=/m/work/t212/unix/work/$USER
#: }}}
