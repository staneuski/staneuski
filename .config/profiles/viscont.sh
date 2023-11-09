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
  echo OpenFOAM@$v:$WM_PROJECT_DIR $WM_COMPILE_OPTION

  export WM_PROJECT_SITE="${HOME}/.local/share/foamio/addons"
  export FOAM_RUN=$HOME/Files/OpenFOAM
}
#: }}}

#: Exports {{{
export WRKDIR=/m/work/t212/unix/work/$USER

export GRIDPRO=/l/Applications/GridPro/GridPro
export PYTHONPATH=$GRIDPRO/lib:$PYTHONPATH

export PATH=$GRIDPRO/bin:$PATH
export PATH=$GRIDPRO/lc_mngr:$PATH
#: }}}

#: Aliases {{{
alias ls='ls --color --group-directories-first'
#: }}}
