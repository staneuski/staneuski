# vim:fileencoding=utf-8:foldmethod=marker
export PATH="${HOME}/.local/bin:${PATH}"

#: Environment {{{
#: Plugin manager (zinit)
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [ ! -d "${ZINIT_HOME}" ]; then
  mkdir -p "$(dirname ${ZINIT_HOME})"
  git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"
fi
source "${ZINIT_HOME}/zinit.zsh"
export MANPATH="$ZINIT[MAN_DIR]:$MANPATH"

#: Terminal tab
[[ $(uname) == "Linux" ]] &&
  export PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME}:${PWD}\007"'
#: }}}

#: Plugins {{{
zinit wait lucid light-mode for \
  zsh-users/zsh-autosuggestions \
  zsh-users/zsh-completions \
  zsh-users/zsh-syntax-highlighting
#: }}}

#: Functions {{{
#: https://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/ (VII)
function fancy-ctrl-z() {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
#: }}}

#: Aliases {{{
zinit wait lucid for \
    OMZP::common-aliases \
    OMZP::command-not-found \
    OMZP::git \
    OMZP::kitty

#: https://www.atlassian.com/git/tutorials/dotfiles
alias stow-git="/usr/bin/git --git-dir=${HOME}/.local/share/dotfiles --work-tree=${HOME}"

#: slurm
(( $+commands[squeue] )) &&
  alias sq='squeue --format="%.8i %.9P %.42j %.8T %.6M %.4D %R" --me'
#: }}}

# Keybindings {{{
bindkey -e
bindkey '^[[3~' delete-char # https://superuser.com/a/1078653
bindkey '^[w' kill-region

#: Switch back Ctrl-Z
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z
#: }}}

#: Intergrations {{{
#: History settings
setopt appendhistory
setopt sharehistory # share command history data
setopt hist_ignore_space # ignore commands that start with space
setopt hist_ignore_all_dups # ignore duplicated commands history list
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

#: Completions
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

#: Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

#: Prevent complete path deletions
autoload -U select-word-style
select-word-style bash

#: Recipes {{{
# 0 prompt, cd, ls
# 1 cli
# 2 tui
# 3 completions, docs
#: atuin
zinit ice wait="1b" lucid from"gh-r" as"command" \
  bpick"atuin*$(uname -m)*${$(uname):l}*.tar.gz" \
  mv"atuin* -> atuin" \
  pick"atuin*/atuin" \
  atclone"atuin*/./atuin init zsh > init.zsh" \
  atpull"%atclone" src"init.zsh" nocompile'!'
zinit light atuinsh/atuin

#: bat 
zinit ice wait="2" lucid from"gh-r" as"command" \
  mv"bat* -> bat" \
  pick"bat*/bat" \
  cp"bat*/autocomplete/bat.zsh -> _bat" \
  atclone"cp -rvf bat*/bat.1 $ZINIT[MAN_DIR]/man1/" \
  atpull"%atclone"
zinit light sharkdp/bat

#: entr
zinit ice wait"1" lucid as"program" configure \
  cp"entr.1 $ZINIT[MAN_DIR]/man1" \
  make"PREFIX=$ZPFX"
zinit light eradman/entr

#: eza
if [[ $(uname) == "Linux" ]]; then
  zinit ice wait"0" lucid from"gh-r" as"program"
  zinit light eza-community/eza
  zinit ice wait"3" lucid from"gh-r" as"completion" \
    id-as"eza-community/eza/complitions" \
    bpick"completions*" \
    mv"**/completions* -> completions" \
    pick"**/complitions*/_eza"
  zinit light eza-community/eza
  zinit ice wait"3" lucid from"gh-r" as"none" \
    id-as"eza-community/eza/man" \
    bpick"man*" \
    mv"**/man* -> man" \
    atclone"cp -rfv **/man*/*.1 $ZINIT[MAN_DIR]/man1/
            cp -rfv **/man*/*.5 $ZINIT[MAN_DIR]/man5/" \
    atpull"%atclone"
  zinit light eza-community/eza
fi
zinit wait"3" lucid for \
  atinit"zstyle ':omz:plugins:eza' 'dirs-first' yes" \
    OMZP::eza

#: fzf (use `fzf --man` instead of `man fzf`)
zinit ice wait"1a" lucid as"command" from"gh-r" \
  atclone"./fzf --zsh > init.zsh" \
  atpull"%atclone" src"init.zsh"
zinit light junegunn/fzf

#: helix (helix does not provide man page)
zinit ice wait"2" lucid from="gh-r" as="program" \
  mv"helix* -> helix" \
  pick"helix*/hx" \
  cp"helix*/contrib/completion/hx.zsh -> _hx"
zinit light helix-editor/helix

#: lf
zinit ice wait"2" lucid from"gh-r" as"program"
zinit light gokcehan/lf
zinit wait"3" lucid for \
  as"completion" cp"lf.zsh -> _lf" \
    https://github.com/gokcehan/lf/blob/master/etc/lf.zsh \
  as"null" cp"lf.1 -> $ZINIT[MAN_DIR]/man1/lf.1" \
    https://github.com/gokcehan/lf/blob/master/lf.1

#: ripgrep
zinit ice wait"1" lucid from"gh-r" as"program" \
  mv="ripgrep* -> ripgrep" \
  cp"*/doc/rg.1 -> $ZINIT[MAN_DIR]/man1/rg.1" \
  pick"ripgrep*/rg"
zinit light BurntSushi/ripgrep

#: treeify ( https://superuser.com/a/1086525 )
(( $+commands[tree] )) ||
zinit wait"1" lucid as"program" for \
  https://git.nullroute.lt/hacks/treeify.git/plain/treeify

#: zoxide ( https://github.com/ajeetdsouza/zoxide/issues/175#issuecomment-841470951 )
zinit ice from"gh-r" as"program" \
  cp"zoxide-*/completions/_zoxide -> _zoxide" \
  atclone"./zoxide init --cmd=cd zsh > init.zsh" \
  atpull"%atclone" src"init.zsh" nocompile'!'
zinit light ajeetdsouza/zoxide

#: starship
zinit ice from"gh-r" as"command" \
  atclone"./starship init zsh > init.zsh
          ./starship completions zsh > _starship" \
  atpull"%atclone" src"init.zsh"
zinit light starship/starship
#: }}}
#: }}}
