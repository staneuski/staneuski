function! ChangeBackground()
  if system("defaults read -g AppleInterfaceStyle") =~ '^Dark'
    set background=dark   " for the dark version of the theme
  else
    set background=light  " for the light version of the theme
  endif
  colorscheme gruvbox

  try
    execute "AirlineRefresh"
  catch
  endtry
endfunction
