for d in vim OpenFOAM ssh; do
  ln -sf .config/$d/ $HOME/.$d
done

ln -sf .config/vim/init.vim $HOME/.vimrc
