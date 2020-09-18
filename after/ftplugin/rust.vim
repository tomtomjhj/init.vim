let b:pear_tree_pairs['|'] = {'closer': '|'}
" TODO: matchit handle < -> non-pair

" Make [[, ]] jump to some of VisItem and MacroRulesDefinition. Doesn't rule
" out item declaration statement.
let s:item_pattern =
            \ '\v^\s*\zs' .
            \ '%(pub\s*(\(.+\))?\s+)?' .
            \ '%((default\s+)?((async|const)\s+)?(unsafe\s*)?(extern\s*r?".*"\s*)?fn' .
            \  '|type|struct|enum|union|((unsafe\s+)?(trait|impl))|extern|macro_rules|mod' .
            \  ')'

func! s:section(back)
    call search(s:item_pattern, a:back ? 'bW' : 'W')
endfunction

nmap <silent><buffer> [[ :call <SID>section(1)<CR>
nmap <silent><buffer> ]] :call <SID>section(0)<CR>
