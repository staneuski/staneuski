call plug#begin('~/.vim/plugged')

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

Plug 'doums/darcula'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'rakr/vim-one'
Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
Plug 'lervag/vim-foam'

call plug#end()

if !has('nvim')
  set autoindent
  set autoread
  set backspace=indent,eol,start
  set complete-=i
  set display=lastline
  set encoding=utf-8
  set formatoptions=tcqj
  set history=10000
  set hlsearch
  set incsearch
  set langnoremap
  set laststatus=2
  set listchars=tab:>\ ,trail:-,nbsp:+
  set mouse=a
  set nrformats=hex
  set sessionoptions-=options
  set smarttab
  set tabpagemax=50
  set tags=./tags;,tags
  set ttyfast
  set viminfo+=!
  set wildmenu
endif
 
" execute 'colorscheme ' . (6 < strftime("%H") && strftime("%H") < 19 ? 'one' : 'darcula')
colorscheme one

autocmd BufNewFile,BufRead *.pvsm set syntax=xml
autocmd BufNewFile,BufRead *.orig,*Dict,*Properties,*Fn,fv* set syntax=cpp
autocmd VimResized * wincmd =

set cmdheight=2 
set nu
set expandtab
set tabstop=4
set cursorline
if v:version > 800
  " set termwinsize=10x0
  command Bterm botright terminal
  command Tterm tab terminal
endif

let g:netrw_altv=1
let g:netrw_banner=0 " hide the banner - `I` to show inside Netrw 
let g:netrw_liststyle=3
let g:netrw_keepdir=0 " https://groups.google.com/g/vim_use/c/6yqU3RX2CWA
