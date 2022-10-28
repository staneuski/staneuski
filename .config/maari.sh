# Maari computers specific settings

# ----- functions ---------------------
function of () {
  if [ $1 == "1906" ] && [ -z ${2+x} ]; then
    module load triton-modules/1.0 openfoam/$1-openmpi-metis
  elif [ -f /opt/openfoam$1/etc/bashrc ] && [ -z ${2+x} ]; then
    . /opt/openfoam$1/etc/bashrc
  elif [ -f $HOME/.local/opt/OpenFOAM-$1/etc/bashrc ]; then
    . $HOME/.local/opt/OpenFOAM-$1/etc/bashrc
  else
    echo OpenFOAM-$1 was not found.
    return 1
  fi

  foamSetUserBins
  unset foamSetUsetBins

  [[ -r $WM_PROJECT_DIR/.build ]] && v=$(cat $WM_PROJECT_DIR/.build) || v=$1
  echo OpenFOAM@$v:$WM_PROJECT_DIR
}


# ----- exports -----------------------
export WRKDIR=/m/work/t212/unix/work/$USER


# ----- aliases -----------------------
