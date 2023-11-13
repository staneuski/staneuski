": vim interface {{{
": Mouse support
set mouse=a
set ttymouse=sgr
set balloonevalterm

": https://vim.fandom.com/wiki/Change_cursor_shape_in_different_modes
let &t_SI.="\e[5 q" "SI = INSERT mode
if v:version > 800
  let &t_SR.="\e[4 q" "SR = REPLACE mode
endif
let &t_EI.="\e[1 q" "EI = NORMAL mode (ELSE)

" Styled and colored underline support
let &t_AU = "\e[58:5:%dm"
let &t_8u = "\e[58:2:%lu:%lu:%lum"
let &t_Us = "\e[4:2m"
let &t_Cs = "\e[4:3m"
let &t_ds = "\e[4:4m"
let &t_Ds = "\e[4:5m"
let &t_Ce = "\e[4:0m"
" Strikethrough
let &t_Ts = "\e[9m"
let &t_Te = "\e[29m"
" Truecolor support
let &t_8f = "\e[38:2:%lu:%lu:%lum"
let &t_8b = "\e[48:2:%lu:%lu:%lum"
let &t_RF = "\e]10;?\e\\"
let &t_RB = "\e]11;?\e\\"
" Bracketed paste
let &t_BE = "\e[?2004h"
let &t_BD = "\e[?2004l"
let &t_PS = "\e[200~"
let &t_PE = "\e[201~"
" Cursor control
let &t_RC = "\e[?12$p"
let &t_SH = "\e[%d q"
let &t_RS = "\eP$q q\e\\"
let &t_SI = "\e[5 q"
let &t_SR = "\e[3 q"
let &t_EI = "\e[1 q"
let &t_VS = "\e[?12l"
" Focus tracking
let &t_fe = "\e[?1004h"
let &t_fd = "\e[?1004l"
execute "set <FocusGained>=\<Esc>[I"
execute "set <FocusLost>=\<Esc>[O"
" Window title
let &t_ST = "\e[22;2t"
let &t_RT = "\e[23;2t"

" vim hardcodes background color erase even if the terminfo file does
" not contain bce. This causes incorrect background rendering when
" using a color theme with a background color in terminals such as
" kitty that do not support background color erase.
let &t_ut=''

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
  colorscheme edge
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

set ai " auto indent
set si " smart indent
set wrap " wrap lines
": }}}

": netrw settings {{{
let g:netrw_altv=1
let g:netrw_banner=0 " hide the banner - `I` to show inside Netrw 
let g:netrw_liststyle=3
let g:netrw_keepdir=0 " https://groups.google.com/g/vim_use/c/6yqU3RX2CWA
": }}}
