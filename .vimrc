source ~/.config/vim/plugins.vim
source ~/.config/vim/functions.vim
source ~/.config/vim/mappings.vim
source ~/.config/vim/interface.vim

": General {{{
set history=1000

": Enable filetype plugins
filetype indent plugin on

": Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * silent! checktime
": }}}
