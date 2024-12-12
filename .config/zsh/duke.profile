# vim:fileencoding=utf-8:foldmethod=marker
# Duke machine (macOS) specific settings 

#: Exports {{{
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"

#: Functions {{{
function of () {
  if [ -f $HOME/.local/opt/OpenFOAM-$1/etc/bashrc ] && [ ! -z ${2+x} ]; then
    sed -i '' "
      s|WM_COMPILE_OPTION=Opt|WM_COMPILE_OPTION=${2}|g;
      s|WM_COMPILE_OPTION=Debug|WM_COMPILE_OPTION=${2}|g
    " $HOME/.OpenFOAM/prefs.sh

    source $HOME/.local/opt/OpenFOAM-$1/etc/bashrc > /dev/null

    sed -i '' "
      s|WM_COMPILE_OPTION=${2}|WM_COMPILE_OPTION=Opt|g
    " $HOME/.OpenFOAM/prefs.sh
  else
    echo OpenFOAM-$1 was not found.
    return 1
  fi

  [[ -r $WM_PROJECT_DIR/.build ]] && v=$(cat $WM_PROJECT_DIR/.build) || v=$1
  echo OpenFOAM@$v:$WM_PROJECT_DIR $WM_COMPILE_OPTION

  export FOAM_RUN="${HOME}/Files/OpenFOAM/cases"
  export WM_PROJECT_SITE="${HOME}/Developer/Projects/froth"
  export PATH="${PATH}:${WM_PROJECT_SITE}/bin"
}
#: }}}

#: Aliases {{{
alias bat="bat --theme=\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo default || echo GitHub)"
alias cattysh="caffeinate -ims kitty +kitten ssh"
alias rsync="rsync --exclude={'.DS_Store','._*'}"
alias tar="COPYFILE_DISABLE=1 tar"
alias mdls-pdf="mdls -name kMDItemTitle \
                     -name kMDItemAuthors \
                     -name kMDItemDescription \
                     -name kMDItemCreator \
                     -name kMDItemKeywords"
alias vlc='/Applications/VLC.app/Contents/MacOS/VLC' 
#: }}}
