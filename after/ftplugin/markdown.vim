" too intrusive
setlocal matchpairs-=<:>
" $VIMRUNTIME/ftplugin/html.vim:31 → remove `<:>,`
if b:match_words[:3] ==# '<:>,'
    let b:match_words = b:match_words[4:]
endif
