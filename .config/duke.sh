# duke machinei (macOS) specific settings 

WRKDIR=${HOME}/Developer

# ----- functions ---------------------
function of () {
  # if [ $1 -eq 2112 ]; then
  #   /Applications/OpenFOAM-v2112.app/Contents/MacOS/openfoam; exit;
  if [ -f $HOME/.local/opt/OpenFOAM-$1/etc/bashrc ]; then
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
export WRKDIR=$HOME/Developer


# ----- aliases -----------------------
