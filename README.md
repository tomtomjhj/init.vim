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
nvim -c PlugInstall
```
