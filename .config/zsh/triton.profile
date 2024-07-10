# vim:fileencoding=utf-8:foldmethod=marker
# Triton cluster (RedHad OS) specific settings

#: Exports {{{
#: Directories
export PROJAPPL="/scratch/eng/t21206-cfd"

#: GridPro
export GRIDPRO=/scratch/eng/t21206-cfd/opt/GridPro
export PYTHONPATH=$GRIDPRO/lib:$PYTHONPATH
export PATH=${PATH}:$GRIDPRO/bin:$PATH
export PATH=${PATH}:$GRIDPRO/lc_mngr:$PATH
#: }}}

#: Functions {{{
function of () {
  if [ -z ${2+x} ]; then
    module load openfoam-org/$1
  elif [ -f $HOME/.local/opt/OpenFOAM-$1/etc/bashrc ]; then
    module load scibuilder-spack-dev/2024-01 openmpi/4.1.6 cmake/3.27.7 gcc/12.3.0 flex/2.6.4 scotch/7.0.4
    sed -i "
        s|WM_COMPILE_OPTION=Opt|WM_COMPILE_OPTION=${2}|g;
        s|WM_COMPILE_OPTION=Debug|WM_COMPILE_OPTION=${2}|g
    " $HOME/.OpenFOAM/prefs.sh

    . ${PROJAPPL}/opt/OpenFOAM-$1/etc/bashrc

    sed -i "s|WM_COMPILE_OPTION=${2}|WM_COMPILE_OPTION=Opt|g
    " $HOME/.OpenFOAM/prefs.sh
  else
    echo OpenFOAM-$1 was not found.
    return 1
  fi

  [[ -r $WM_PROJECT_DIR/.build ]] && v=$(cat $WM_PROJECT_DIR/.build) || v=$1
  echo OpenFOAM@$v:$WM_PROJECT_DIR

  export WM_PROJECT_SITE="${PROJAPPL}/etc/froth"
  export PATH=${PATH}:${WM_PROJECT_SITE}/bin
}
#: }}}

#: Aliases {{{
sb () { sbatch "$@" }
sr () { srun "$@" }
srt () { srun --partition=interative --time=00:15:00 "$@" }
#: }}}
