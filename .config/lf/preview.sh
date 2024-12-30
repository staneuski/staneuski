#!/usr/bin/env zsh
# https://github.com/gokcehan/lf/issues/904#issuecomment-1331826453
# https://github.com/sharkdp/bat#dark-mode
function get_theme() {
  [[ $(uname) == "Darwin" ]] &&
    (defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo Dracula || echo GitHub) || 
  grep -- '--theme=' ~/.config/bat/config | sed -E 's/^--theme="([^"]+)"/\1/'
}

# [[ $(uname) == "Darwin" ]] &&
#   _theme=$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo default || echo GitHub) ||
#   _theme=default

case "$1" in
  *.tar*)
    tar tf "$1"
    ;;
  *.zip)
    unzip -l "$1"
    ;;
  # *.rar)
  #   unrar l "$1"
  #   ;;
  # *.7z)
  #   7z l "$1"
  #   ;;
  # *.pdf)
  #   pdftotext "$1" -
  #   ;;
  *)
    # return false to always repaint, in case terminal size changes
    bat \
      --plain \
      --theme="$(get_theme)" \
      --force-colorization \
      --style=changes \
      --terminal-width $(($2 - 3)) "$1" && false
    ;;
esac
