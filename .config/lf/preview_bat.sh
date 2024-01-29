#!/usr/bin/env bash
# https://github.com/gokcehan/lf/issues/904#issuecomment-1331826453

if [[ $(uname) == "Darwin" ]]; then
  MIME=$(file --mime-type --brief "$1")
  THEME=$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo default || echo GitHub)
else
  MIME=$(mimetype --all --brief "$1")
fi

function _viewer() {

  return $?
}

case "$MIME" in
  *application/pdf*)
    pdftotext "$1" -
    ;;
  *application/x-7z-compressed*)
    7z l "$1"
    ;;
  *application/x-tar* | *application/x-compressed-tar* | *application/x-*-compressed-tar* | *application/x-xz)
    tar -tf "$1"
    ;;
  # .rar
  *application/vnd.rar*)
    unrar l "$1"
    ;;
  # .zip
  *application/zip*)
    unzip -l "$1"
    ;;
  # any plain text file that doesn't have a specific handler
  *text/*)
    # return false to always repaint, in case terminal size changes
    bat \
      --plain \
      --theme=$THEME \
      --force-colorization \
      --style=changes \
      --terminal-width $(($2 - 3)) "$1" && false
    ;;
  *)
    echo "unknown format '$MIME'"
    ;;
esac
