#!/usr/bin/env bash

if [[ "$(uname)" == "Darwin" ]]; then
  get_mime() { file -Ib "$1" | cut -d';' -f1; }
else
  get_mime() { file --mime-type -b "$1"; }
fi

case "$(get_mime "$1")" in
  application/x-tar)
    tar -tf "$1"
    ;;
  application/gzip)
    tar -tzf "$1"
    ;;
  application/x-gzip)
    gzip -cd "$1"
    ;;
  application/x-xz)
    tar -tJf "$1" 2>/dev/null || xz -cd "$1"
    ;;
  application/zip)
    unzip -l "$1"
    ;;
  application/x-rar)
    unrar l "$1"
    ;;
  application/x-7z-compressed)
    7z l "$1"
    ;;
  # application/pdf)
  #   pdftotext "$1" -
  #   ;;
  *)
    # return false to always repaint, in case terminal size changes
    bat \
      --plain \
      --theme="${lf_user_theme}" \
      --force-colorization \
      --style=changes \
      --terminal-width $(($2 - 3)) "$1" && false
    ;;
esac
