" fixed by https://github.com/neovim/neovim/pull/14946
syn region	vimPlug	oneline excludenl matchgroup=vimUserCmd start="\<Plug\>" skip="\(\\\\\)*\\|" end="$\||" contains=vimFuncVar,vimIsCommand,vimOper,vimNotation,vimOperParen,vimString,vimVar,vimComment
