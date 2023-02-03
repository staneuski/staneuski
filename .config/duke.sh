# vim:fileencoding=utf-8:foldmethod=marker
# Duke machine (macOS) specific settings 

#: Functions {{{
function of () {
  if [ -f $HOME/.local/opt/OpenFOAM-$1/etc/bashrc ] && [ ! -z ${2+x} ]; then
    sed -i '' "
      s|WM_COMPILE_OPTION=Opt|WM_COMPILE_OPTION=${2}|g;
      s|WM_COMPILE_OPTION=Debug|WM_COMPILE_OPTION=${2}|g
    " $HOME/.OpenFOAM/prefs.sh

    . $HOME/.local/opt/OpenFOAM-$1/etc/bashrc > /dev/null

    sed -i '' "s|WM_COMPILE_OPTION=${2}|WM_COMPILE_OPTION=Opt|g
    " $HOME/.OpenFOAM/prefs.sh
  else
    echo OpenFOAM-$1 was not found.
    return 1
  fi

  export FOAM_USER_APPBIN=$HOME/.local/opt/$WM_PROJECT-$WM_PROJECT_VERSION/platforms/$WM_OPTIONS/bin
  export FOAM_USER_LIBBIN=$HOME/.local/opt/$WM_PROJECT-$WM_PROJECT_VERSION/platforms/$WM_OPTIONS/lib

  [[ -r $WM_PROJECT_DIR/.build ]] && v=$(cat $WM_PROJECT_DIR/.build) || v=$1
  echo OpenFOAM@$v:$WM_PROJECT_DIR $WM_COMPILE_OPTION
}
#: }}}

#: Exports {{{
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export WRKDIR=$HOME/Developer
#: }}}

#: Aliases {{{
alias bat="bat --theme=\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo default || echo GitHub)"
alias rsync="rsync --exclude={'.DS_Store','._*'}"
alias tar="tar --exclude=.DS_Store --exclude='._*'"
alias mdls-pdf="mdls -name kMDItemTitle \
                     -name kMDItemAuthors \
                     -name kMDItemDescription \
                     -name kMDItemCreator \
                     -name kMDItemKeywords"
#: }}}
