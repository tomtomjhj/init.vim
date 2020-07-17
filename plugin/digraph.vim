function s:SetupDigraph()
    digraph mt 8614
    digraph ** 8727
    digraph oo 9679
    digraph OO 9711
    digraph mt 8614
    digraph \|- 8866
    digraph \|= 8872
    digraph ~> 8669
    digraph [\| 10214
    digraph \|] 10215
    digraph bt 8869
    digraph tp 8868
    " override crappy angle bracket
    digraph </ 10216
    digraph /> 10217
    exec 'digraph (> 8618' | " ↪
    digraph [U 8851 " ⊓
    digraph ]U 8852 " ⊔
    digraph =[ 8849 " ⊑
    digraph v^ 8652 " ⇌
    exec 'digraph (+ 8713 " ∉'
    digraph ^= 8796 " ≜

    " tip: use <c-a> and set nrformats+=alpha to increment stuff
    digraph bA 120120
    digraph bB 120121
    digraph bC 8450
    digraph bD 120123
    digraph bE 120124
    digraph bF 120125
    digraph bG 120126
    digraph bH 8461
    digraph bI 120128
    digraph bJ 120129
    digraph bK 120130
    digraph bL 120131
    digraph bM 120132
    digraph bN 8469
    digraph bO 120134
    digraph bP 8473
    digraph bQ 8474
    digraph bR 8477
    digraph bS 120138
    digraph bT 120139
    digraph bU 120140
    digraph bV 120141
    digraph bW 120142
    digraph bX 120143
    digraph bY 120144
    digraph bZ 8484
    " ♯ MX

    unmap! <C-space>
    noremap! <C-space> <C-k>
    return ''
endfunction

noremap! <C-space> <C-R>=<SID>SetupDigraph()<CR><C-K>
