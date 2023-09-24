# Install

```sh
git clone https://github.com/tomtomjhj/init.vim ~/.vim

# -nix
mkdir ~/.config/nvim -p
cd ~/.config/nvim && ln -s ~/.vim/init.vim
cd && ln -s ~/.vim/.vimrc

# windows (administrator)
mklink C:\Users\you\AppData\Local\nvim\init.vim C:\Users\you\.vim\init.vim
mklink C:\Users\you\AppData\Local\nvim\ginit.vim C:\Users\you\.vim\ginit.vim
mklink C:\Users\you\_vimrc C:\Users\you\.vim\.vimrc
mklink C:\Users\you\_gvimrc C:\Users\you\.vim\.gvimrc

nvim -c PlugInstall
cd ~/.vim
./patches/apply.sh
```

# External dependencies
```sh
pip3 install --user pynvim neovim-remote

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install ripgrep fd-find bat

curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs yarn
```

# Note
* windows vim
    * https://github.com/vim/vim-win32-installer
    * python3: use vim's version, 64bit, install locally, put in PATH,

* clean backup/undo files
  ```
  fd -uuu --changed-before 1month --exclude .gitignore '' undo undoo backup -x rm
  ```

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
make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=$HOME/.local
make install
```
