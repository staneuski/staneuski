": vim interface {{{
": Turn on the Wild menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

": Always show current position
set ruler

": Height of the command bar
set cmdheight=1

": A buffer becomes hidden when it is abandoned
set hid

": Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

": Ignore case when searching
" set ignorecase

": When searching try to be smart about cases
set smartcase

": Highlight search results
set hlsearch

": Makes search act like search in modern browsers
set incsearch

": Don't redraw while executing macros (good performance config)
set lazyredraw

": For regular expressions turn magic on
" set magic

": Show matching brackets when text indicator is over them
set showmatch

": How many tenths of a second to blink when matching brackets
set mat=2

": No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500
": }}}

": Colors and fonts {{{
": Enable syntax highlighting
syntax enable

": Show line numbers
set number

": Set regular expression engine automatically
" set regexpengine=0

" Enable 256 colors palette and set colorscheme
set t_Co=256
try
  colorscheme one
catch
endtry
": }}}

": File settings {{{
": Set utf-8 as standard encoding and en_US as the standard language
set encoding=utf8

": Turn backup off
" set nobackup
" set nowb
" set noswapfile
": }}}

": Text, tab and indent related {{{
": Use spaces instead of tabs
set expandtab

": Be smart when using tabs ;)
set smarttab

": 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

": Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines
": }}}
