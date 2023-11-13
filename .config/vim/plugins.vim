call plug#begin('~/.vim/plugged')

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

": Theme
Plug 'sainnhe/edge'

": Syntax support
Plug 'axvr/org.vim'

": Preserve cursor after reopen
Plug 'farmergreg/vim-lastplace'

call plug#end()
": }}}
