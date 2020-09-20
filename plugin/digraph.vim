" search ^I..^I
function s:SetupDigraph()
    digraph mt 8614
    digraph ** 8727
    digraph oo 9679
    digraph OO 9711
    digraph mt 8614
    digraph \|- 8866
    digraph -\| 8867
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
    digraph ]= 8850 " ⊒
    digraph ~< 8818 " ≲
    digraph v^ 8652 " ⇌
    exec 'digraph (+ 8713 " ∉'
    digraph ^= 8796 " ≜
    digraph U+ 8846 " ⊎
    digraph =v 8659 " ⇓
    digraph ZV 8623 " ↯

    digraph _l 8343 " ₗ
    digraph ^a 7491 " ᵃ
    digraph ^c 7580 " ᶜ
    digraph ^e 7497 " ᵉ
    digraph ^l 737  " ˡ
    digraph ^r 691  " ʳ
    digraph ^x 739  " ˣ
    digraph OX 9760 " ☠
    digraph tl 8988 " ⌜ top left corner
    digraph tr 8989 " ⌝
    digraph lu 9121 " ⎡ left square bracket upper corner
    digraph ru 9124 " ⎤

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

    " 𝓐
    " 𝓑
    " 𝓒
    " 𝓓
    " 𝓔
    " 𝓕
    " 𝓖
    " 𝓗
    " 𝓘
    " 𝓙
    " 𝓚
    digraph sL 120027
    " 𝓜
    " 𝓝
    " 𝓞
    digraph sP 120031
    " 𝓠
    " 𝓡
    digraph sS 120034
    digraph sT 120035
    " 𝓤
    digraph sV 120037
    " 𝓦
    " 𝓧
    " 𝓨
    " 𝓩

    unmap! <C-space>
    noremap! <C-space> <C-k>
    return ''
endfunction

noremap! <C-space> <C-R>=<SID>SetupDigraph()<CR><C-K>
