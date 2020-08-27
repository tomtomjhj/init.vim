let b:pear_tree_pairs = extend(deepcopy(g:pear_tree_pairs), {
            \ '$': {'closer': '$'},
            \ '$$': {'closer': '$$'},
            \ '`': {'closer': '`'},
            \ '```': {'closer': '```'},
            \ })

let b:match_words = &l:matchpairs .
      \ ',' . '\%(^\s*\)\@<=\\begin{\(\w\+\*\?\)}' . ':' . '\%(^\s*\)\@<=\\end{\1}'
