#!/usr/bin/env bash

#: bat
(
  # https://github.com/sharkdp/bat?tab=readme-ov-file#adding-new-themes
  mkdir -p "$(bat --config-dir)/themes/"

  for flavour in day moon night storm; do
    curl -LO https://raw.githubusercontent.com/folke/tokyonight.nvim/master/extras/sublime/tokyonight_${flavour}.tmTheme \
      --output-dir "$(bat --config-dir)/themes"
  done
  bat cache --build
)

#: kitty
(
  mkdir -p ~/.config/kitty/themes/

  for flavour in day moon night storm; do
    curl -LO https://raw.githubusercontent.com/folke/tokyonight.nvim/master/extras/kitty/tokyonight_${flavour}.conf \
      --output-dir ~/.config/kitty/themes/
  done

  ln -sfn themes/tokyonight_night.conf ~/.config/kitty/dark-theme.auto.conf
  ln -sfn themes/tokyonight_day.conf ~/.config/kitty/light-theme.auto.conf
)
