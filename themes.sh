#!/usr/bin/env bash

#: bat
(
  # https://github.com/sharkdp/bat?tab=readme-ov-file#adding-new-themes
  OUT="$(bat --config-dir)/themes"

  mkdir -p "${OUT}"
  for flavour in day moon night storm; do
    curl -LO https://raw.githubusercontent.com/folke/tokyonight.nvim/master/extras/sublime/tokyonight_${flavour}.tmTheme \
      --output-dir "${OUT}"
  done
  bat cache --build
)

#: kitty
(
  OUT="${HOME}/.config/kitty/themes/"

  mkdir -p "${OUT}"
  for flavour in day moon night storm; do
    curl -LO https://raw.githubusercontent.com/folke/tokyonight.nvim/master/extras/kitty/tokyonight_${flavour}.conf \
      --output-dir "${OUT}"
  done

  ln -sfn themes/tokyonight_night.conf "${HOME}/.config/kitty/dark-theme.auto.conf"
  ln -sfn themes/tokyonight_day.conf "${HOME}/.config/kitty/light-theme.auto.conf"
)

#: vim
(
  OUT="${HOME}/.config/.vim/colors/"

  mkdir -p "${OUT}"
  for flavour in day moon night storm; do
    curl -LO https://raw.githubusercontent.com/folke/tokyonight.nvim/refs/heads/main/extras/vim/colors/tokyonight-${flavour}.vim \
      --output-dir "${OUT}"
  done

  echo "runtime colors/tokyonight-moon.vim" > "${OUT}/tokyonight.vim"
)
