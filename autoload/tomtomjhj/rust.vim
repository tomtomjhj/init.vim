" Make [[, ]] jump to some of VisItem and MacroRulesDefinition. Doesn't rule
" out item declaration statement.
let s:item_pattern =
            \ '\v^\s*\zs' .
            \ '%(pub\s*(\(.+\))?\s+)?' .
            \ '%((default\s+)?((async|const)\s+)?(unsafe\s*)?(extern\s*r?".*"\s*)?fn' .
            \  '|type|struct|enum|union|((unsafe\s+)?(trait|impl))|extern|macro_rules|mod' .
            \  ')'

function! tomtomjhj#rust#section(back) abort
    call search(s:item_pattern, a:back ? 'bW' : 'W')
endfunction
