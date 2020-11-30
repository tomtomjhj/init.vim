" https://github.com/tmsvg/pear-tree/pull/27
let b:pear_tree_pairs = extend(deepcopy(g:pear_tree_pairs), {
            \ '\\begin{*}': {'closer': '\\end{*}', 'until': '[{}[:space:]]'},
            \ '$$': {'closer': '$$'},
            \ '$': {'closer': '$'}
            \ }, 'keep')
