# Install

```sh
git clone https://github.com/tomtomjhj/init.vim ~/.vim
git submodule update --init
```

```vim
" ~/.config/nvim/init.vim
if has('nvim')
  set runtimepath+=~/.vim
  set runtimepath+=~/.vim/after
endif
source ~/.vim/configs.vim
```

```sh
pip3 install --user pynvim
nvim -c PlugInstall
```
