# vim:fileencoding=utf-8:foldmethod=marker
# Duke machine (macOS) specific settings 

#: Functions {{{
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
of dev Debug &> /dev/null
#: }}}

#: Exports {{{
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
