": Mappings {{{
" let mapleader = ","

": Fast saving
nmap <leader>w :w!<cr>

": :W sudo saves the file (to handle the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!
": }}}

": Syntax {{{
": OpenFOAM
autocmd BufNewFile,BufRead *.orig,*Dict,*Properties,*Properties.*,*Fn,fv* set syntax=cpp
autocmd BufNewFile,BufRead *.pvsm* set syntax=xml
": }}}
