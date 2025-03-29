#!/usr/bin/env sh
set -euo pipefail

usage() {
  cat <<EOF
positional arguments:
  MODE {light,dark}     set the theme to light or dark
options:
  -h, --help            show this help message and exit
  -v,--verbose          output information
EOF
}

parse_args() {
  while [ $# -gt 0 ]; do
    case $1 in
    -h | --help)
      usage
      exit 0
      ;;
    -v | --verbose)
      set -x
      shift
      ;;
    light | dark)
      MODE=$1
      shift
      ;;
    *)
      echo "unknown parameter passed: $1"
      usage
      exit 1
      ;;
    esac
  done

  if [ -z ${MODE+x} ]; then
    echo "no mode specified; use 'light' or 'dark'."
    exit 1
  fi
}

is_gnome() {
  command -v gsettings &>/dev/null &&
    gsettings get org.gnome.desktop.interface color-scheme &>/dev/null
}

toggle() {
  declare gnome="${1}" kitty="${2}" lf="${3}" vim="${4}"
  local helix="${kitty}"

  #: gnome
  is_gnome &&
    gsettings set org.gnome.desktop.interface color-scheme "${gnome}"

  #: helix
  sed -i'.old' "s/^theme.*=.*$/theme = \"${helix}\"/g" \
    "${HOME}/.config/helix/config.toml"

  #: kitty
  ln -sfn "themes/${kitty}.conf" "${HOME}/.config/kitty/current-theme.conf"

  #: lf
  command -v yq >/dev/null &&
    yq ".preview.theme = \"${lf}\"" -i "${HOME}/.config/lf/config.yaml"

  #: vim
  printf "runtime colors/${vim}.vim\n" >"${HOME}/.vim/colors/tokyonight.vim"
}

parse_args "$@"

if [ ${MODE} == "dark" ]; then
  toggle 'prefer-dark' 'tokyonight_moon' 'dark' 'tokyonight-moon'
elif [ ${MODE} == "light" ]; then
  toggle 'prefer-light' 'tokyonight_day' 'light' 'tokyonight-day'
else
  echo "unknown mode: ${MODE}"
  usage
  exit 1
fi
