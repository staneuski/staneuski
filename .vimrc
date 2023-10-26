source ~/.config/vim/plugins.vim
source ~/.config/vim/interface.vim
source ~/.config/vim/mappings.vim

": General {{{
set history=1000

": Enable filetype plugins
filetype indent plugin on

": Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * silent! checktime
": }}}
