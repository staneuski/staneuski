# vim:fileencoding=utf-8:foldmethod=marker
# mahti and puhti CSC clusters (RedHad OS) specific settings

#: Functions {{{
function of () {
  if [ -z ${2+x} ]; then
    module load csc-tools openfoam/$1
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
  export WM_PROJECT_SITE=${PROJAPPL}/froth
  export PATH=${PATH}:${WM_PROJECT_SITE}/bin

  module load python-data
  export PYTHONUSERBASE=${PROJAPPL}/pyenv
  export PYTHONPATH=${PYTHONUSERBASE}/lib/python3.*/site-packages/ && \
  export PATH=${PATH}:${PYTHONUSERBASE}/bin
}
#: }}}

#: Aliases {{{
sb () { sbatch --account="project_${PRJ_ID}" "$@" }
sr () { srun --account="project_${PRJ_ID}" "$@" }
srt () { srun --account="project_${PRJ_ID}" --partition=test --time=00:15:00 "$@" }
#: }}}
