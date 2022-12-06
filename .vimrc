": Vim Plug {{{
call plug#begin('~/.vim/plugged')

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plug 'itchyny/lightline.vim'

": Syntax {{{
" Plug 'vim-python/python-syntax'
Plug 'suan/vim-instant-markdown', {'rtp': 'after'} " Markdown preview
Plug 'luochen1990/rainbow' " rainbow brackets
Plug 'lervag/vim-foam'
": }}}

": Colors {{{
Plug 'doums/darcula'
Plug 'rakr/vim-one'
": }}}"
call plug#end()
": }}}


": General {{{
autocmd VimResized * wincmd = " auto resize

set cmdheight=2 
set clipboard=unnamedplus " copy/paste between vim and other programs
set number " show line numbers

": Reproduce neovim settings
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
  set tabpagemax=50
  set tags=./tags;,tags
  set ttyfast
  set viminfo+=!
  set wildmenu
endif
": }}}


": netrw {{{
let g:netrw_altv=1
let g:netrw_banner=0 " hide the banner - `I` to show inside Netrw 
let g:netrw_liststyle=3
let g:netrw_keepdir=0 " https://groups.google.com/g/vim_use/c/6yqU3RX2CWA
": }}}


": Design {{{
set t_Co=256 " support 256 colors
set termguicolors
" execute 'colorscheme ' . (6 < strftime("%H") && strftime("%H") < 19 ? 'one' : 'darcula')
colorscheme one

" https://vim.fandom.com/wiki/Change_cursor_shape_in_different_modes
let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[4 q" "SR = REPLACE mode
let &t_EI.="\e[1 q" "EI = NORMAL mode (ELSE)


": Syntax mappings {{{
": OpenFOAM
autocmd BufNewFile,BufRead *.orig,*Dict,*Properties,*Fn,fv* set syntax=cpp
autocmd BufNewFile,BufRead *.pvsm* set syntax=xml
": }}}
": }}}


": Text, tab & indent {{{
set cursorline
set expandtab " use spaces
set smarttab
set shiftwidth=4
set tabstop=4
": }}}


": Customisations {{{
": Commands {{{
if v:version > 800
  " set termwinsize=10x0
  command Bterm botright terminal
  command Tterm tab terminal
endif
": }}}

": Mappings {{{
" Change 2 split windows from vert to horiz or horiz to vert
map <Leader>th <C-w>t<C-w>H
map <Leader>tk <C-w>t<C-w>K
": }}}
": }}}
