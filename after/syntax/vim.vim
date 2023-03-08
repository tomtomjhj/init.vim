" fixed by https://github.com/neovim/neovim/pull/14946
syn region	vimPlug	oneline excludenl matchgroup=vimUserCmd start="\<Plug\>" skip="\(\\\\\)*\\|" end="$\||" contains=vimFuncVar,vimIsCommand,vimOper,vimNotation,vimOperParen,vimString,vimVar,vimComment

" my command for :map without :smap
syn keyword	vimMap		Map Noremap skipwhite nextgroup=vimMapMod,vimMapLhs


" don't prefer the bundled syntax/lua.vim
let s:luapath = split(globpath(&rtp,"syntax/lua.vim"),"\n")[0]
if g:vimsyn_embed =~# 'l' && filereadable(s:luapath)
    syn cluster vimFuncBodyList remove=vimLuaRegion
    syn clear @vimLuaScript
    syn clear vimLuaRegion

    unlet! b:current_syntax
    syn cluster vimFuncBodyList	add=vimLuaRegion
    exe "syn include @vimLuaScript ".s:luapath
    syn region vimLuaRegion matchgroup=vimScriptDelim start=+lua\s*<<\s*\z(.*\)$+ end=+^\z1$+	contains=@vimLuaScript
    syn region vimLuaRegion matchgroup=vimScriptDelim start=+lua\s*<<\s*$+ end=+\.$+	contains=@vimLuaScript
    syn cluster vimFuncBodyList	add=vimLuaRegion
endif
unlet! s:luapath
