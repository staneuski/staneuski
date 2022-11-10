# vim:fileencoding=utf-8:foldmethod=marker
# mahti and puhti CSC clusters (RedHad OS) specific settings

#: Functions {{{
function of () {
  if [ -z ${2+x} ]; then
    module load csc-tools openfoam/$1
  # elif [ -f $HOME/.local/opt/OpenFOAM-$1/etc/bashrc ]; then
  #   module load bison cmake gcc scotch flex
  #   . $HOME/.local/opt/OpenFOAM-$1/etc/bashrc
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

#: Exports {{{
export PRJ_ID=2004997
export WRKDIR="/scratch/project_${PRJ_ID}/${USER}/"
#: }}}

#: Aliases {{{
alias ls='ls --color --group-directories-first'
alias sbatch="sbatch --account=project_${PRJ_ID}"
#: }}}
