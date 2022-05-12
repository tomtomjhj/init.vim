# Install

```sh
git clone https://github.com/tomtomjhj/init.vim ~/.vim

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
```

# External dependencies
```sh
pip3 install --user pynvim neovim-remote

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install ripgrep fd-find bat

curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
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

# TODO
* win gvim
    * `z=` slow (only in win gvim)
    * fzf stuff is unusable, cmd.exe bad, `preview.sh: line 2: $'\r': command not found`
        * `set shell=STUFF` completely breaks fzf (maybe related to `fzf#exec()`)
    * using wsl for `:terminal`?
        * https://vi.stackexchange.com/q/16386
        * https://github.com/vim/vim/issues/2525
        * https://github.com/junegunn/fzf/issues/1191
    * powershell?
        * 8.2.3079
        * neovim #14349, https://github.com/neovim/neovim/pull/16271
