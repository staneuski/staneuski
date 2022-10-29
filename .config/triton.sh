# vim:fileencoding=utf-8:foldmethod=marker
# Triton cluster (RedHad OS) specific settings

#: Functions {{{
function of () {
  if [ -z ${2+x} ]; then
    module load openfoam-org/$1-openmpi-metis
  elif [ -f $HOME/.local/opt/OpenFOAM-$1/etc/bashrc ]; then
    module load bison cmake gcc scotch flex
    . $HOME/.local/opt/OpenFOAM-$1/etc/bashrc
  else
    echo OpenFOAM-$1 was not found.
    return 1
  fi

  foamSetUserBins
  unset foamSetUserBins

  [[ -r $WM_PROJECT_DIR/.build ]] && v=$(cat $WM_PROJECT_DIR/.build) || v=$1
  echo OpenFOAM@$v:$WM_PROJECT_DIR
}
#: }}}
