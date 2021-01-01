# Install

```sh
git clone https://github.com/tomtomjhj/init.vim ~/.vim
pip3 install --user pynvim neovim-remote

# -nix
mkdir ~/.config/nvim -p
cd ~/.config/nvim && ln -s ~/.vim/init.vim && ln -s ~/.vim/ginit.vim
cd && ln -s ~/.vim/.vimrc && ln -s ~/.vim/.gvimrc

# windows (administrator)
mklink C:\Users\you\AppData\Local\nvim\init.vim C:\Users\you\.vim\init.vim
mklink C:\Users\you\AppData\Local\nvim\ginit.vim C:\Users\you\.vim\ginit.vim
mklink C:\Users\you\_vimrc C:\Users\you\.vim\.vimrc
mklink C:\Users\you\_gvimrc C:\Users\you\.vim\.gvimrc

nvim -c PlugInstall

cargo install ripgrep fd-find bat
```

# Note
* https://www.rust-lang.org/tools/install
* `~/.config/bat/config`
  ```
  --theme="zenburn"
  --map-syntax "*.v:SML"
  ```
* windows vim
    * https://github.com/vim/vim-win32-installer
    * python3: 64bit, install locally, put in PATH
    * `:h terminal.txt`?
    * using wsl as terminal?
        * https://vi.stackexchange.com/q/16386
        * https://github.com/vim/vim/issues/2525
        * https://github.com/junegunn/fzf/issues/1191

# compile (n)vim
```bash
sudo apt install ...
./configure \
    --enable-python3interp=yes \
    --with-python3-config-dir=$(python3-config --configdir) \
    --prefix=${HOME}/.local
```

```
sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip
make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=..
make install
```

# TODO
* [x] linux nvim
* [ ] win gvim
    * `C-+/-` to zoom in/out
* [ ] linux vim 7.4: minimal, pure vimscript
* [ ] nvim vimscript + lua
