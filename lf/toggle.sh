#!/usr/bin/env bash
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
  local is_dark="${1}" gnome="${2}" kitty="${3}" lf="${4}" vim="${5}"
  local bat="${lf}"
  local helix="${kitty}"

  #: gnome
  if is_gnome; then
    gsettings set org.gnome.desktop.interface color-scheme "${gnome}"
    gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled "${is_dark}"
  fi

  #: bat
  sed -i'.old' "s/^--theme\=.*$/--theme=\"${bat}\"/g" \
    "${HOME}/.config/bat/config"

  #: helix
  sed -i'.old' "s/^theme.*=.*$/theme = \"${helix}\"/g" \
    "${HOME}/.config/helix/config.toml"

  #: kitty
  ln -sfn "themes/${kitty}.conf" "${HOME}/.config/kitty/current-theme.conf"

  #: lf
  sed -i'.old' "s/^set.*user_theme.*$/set user_theme ${lf}/g" \
    "${HOME}/.config/lf/lfrc"

  #: vim
  printf "runtime colors/${vim}.vim\n" >"${HOME}/.vim/colors/tokyonight.vim"
}

parse_args "$@"

if [ ${MODE} == "dark" ]; then
  toggle 'true' 'prefer-dark' 'tokyonight_moon' 'dark' 'tokyonight-moon'
elif [ ${MODE} == "light" ]; then
  toggle 'false' 'prefer-light' 'tokyonight_day' 'light' 'tokyonight-day'
else
  echo "unknown mode: ${MODE}"
  usage
  exit 1
fi
