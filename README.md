# Install

```sh
git clone https://github.com/tomtomjhj/init.vim ~/.vim
git submodule update --init
```

```vim
" ~/.config/nvim/init.vim
set runtimepath+=~/.vim
set runtimepath+=~/.vim/after
source ~/.vim/configs.vim
```

```sh
pip3 install --user pynvim
nvim -c PlugInstall
```
