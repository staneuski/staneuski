# vim:fileencoding=utf-8:foldmethod=marker
# Triton cluster (RedHad OS) specific settings

#: Exports {{{
#: Directories
export PROJAPPL="/scratch/eng/t21206-cfd"

#: GridPro
export GRIDPRO=/scratch/eng/t21206-cfd/opt/GridPro
export PYTHONPATH=$GRIDPRO/lib:$PYTHONPATH
append_pathenv $GRIDPRO/bin:$PATH
append_pathenv $GRIDPRO/lc_mngr:$PATH
#: }}}

#: Functions {{{
function of () {
  if [ -z ${2+x} ]; then
    module load openfoam-org/$1-openmpi-metis
  elif [ -f $HOME/.local/opt/OpenFOAM-$1/etc/bashrc ]; then
    module load bison cmake gcc scotch flex
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

  [[ -r $WM_PROJECT_DIR/.build ]] && v=$(cat $WM_PROJECT_DIR/.build) || v=$1
  echo OpenFOAM@$v:$WM_PROJECT_DIR

  export FOAM_RUN="${WRKDIR}/OpenFOAM/cases"
  export WM_PROJECT_SITE="${PROJAPPL}/etc/froth"
  append_pathenv ${WM_PROJECT_SITE}/bin
}
#: }}}

#: Aliases {{{
alias ls='ls --color --group-directories-first'
#: }}}
