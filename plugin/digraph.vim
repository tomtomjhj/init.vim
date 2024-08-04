" * search ^I..^I
" * use <c-a> with set nrformats+=alpha
" * char2nr
function! s:SetupDigraph()
    digraph mt 8614 " ↦
    digraph mf 8612 " ↤
    digraph Mt 10503 " ⤇
    digraph ** 8727
    digraph oo 9679
    digraph OO 9711
    digraph \|- 8866
    digraph -\| 8867
    digraph \|= 8872
    digraph ~> 8669
    digraph [\| 10214
    digraph \|] 10215
    digraph bt 8869
    digraph tp 8868
    " override crappy angle bracket that occupies 2 cells
    digraph </ 10216
    digraph /> 10217
    exe 'digraph (> 8618' | " ↪
    digraph fm 8640 " ⇀
    digraph \< 8828 " ≼
    digraph ~< 8830 " ≾
    digraph [U 8851 " ⊓
    digraph ]U 8852 " ⊔
    digraph [C 8847 " ⊏
    digraph ]C 8848 " ⊐
    digraph [_ 8849 " ⊑
    digraph ]_ 8850 " ⊒
    digraph v^ 8652 " ⇌
    exe 'digraph (+ 8713 " ∉'
    digraph =^ 8796 " ≜
    digraph U+ 8846 " ⊎
    digraph U. 8845 " ⊍
    digraph =v 8659 " ⇓
    digraph ZV 8623 " ↯
    digraph \\ 8726 " ∖
    digraph OX 9760 " ☠
    digraph tl 8988 " ⌜ top left corner
    digraph tr 8989 " ⌝
    digraph lu 9121 " ⎡ left square bracket upper corner
    digraph ru 9124 " ⎤

    digraph _0 8320
    digraph _1 8321
    digraph _2 8322
    digraph _3 8323
    digraph _4 8324
    digraph _5 8325
    digraph _6 8326
    digraph _7 8327
    digraph _8 8328
    digraph _9 8329
    digraph _+ 8330
    digraph _- 8331
    digraph _= 8332
    digraph ^0 8304
    digraph ^1  185
    digraph ^2  178
    digraph ^3  179
    digraph ^4 8308
    digraph ^5 8309
    digraph ^6 8310
    digraph ^7 8311
    digraph ^8 8312
    digraph ^9 8313
    digraph ^+ 8314
    digraph ^- 8315
    digraph ^= 8316
    exe 'digraph ^( 8317'
    exe 'digraph ^) 8318'

    " conflict: ascii control chars
    " digraph ^A ᴬ
    " digraph ^B ᴮ
    " digraph ^D ᴰ
    " digraph ^E ᴱ
    " digraph ^G ᴳ
    " digraph ^H ᴴ
    " digraph ^I ᴵ
    " digraph ^J ᴶ
    " digraph ^K ᴷ
    " digraph ^L ᴸ
    " digraph ^M ᴹ
    " digraph ^N ᴺ
    " digraph ^O ᴼ
    " digraph ^P ᴾ
    " digraph ^R ᴿ
    " digraph ^T ᵀ
    " digraph ^U ᵁ
    " digraph ^V ⱽ
    " digraph ^W ᵂ
    digraph ^a 7491
    digraph ^b 7495
    digraph ^c 7580
    digraph ^d 7496
    digraph ^e 7497
    digraph ^f 7584
    digraph ^g 7501
    digraph ^h 688
    digraph ^i 8305
    digraph ^j 690
    digraph ^k 7503
    digraph ^l 737
    digraph ^m 7504
    digraph ^n 8319
    digraph ^o 7506
    digraph ^p 7510 " no q
    digraph ^r 691
    digraph ^s 738
    digraph ^t 7511
    digraph ^u 7512
    digraph ^v 7515
    digraph ^w 695
    digraph ^x 739
    digraph ^y 696
    digraph ^z 7611
    digraph _a 8336
    digraph _e 8337
    digraph _h 8341
    digraph _i 7522
    digraph _j 11388
    digraph _k 8342
    digraph _l 8343
    digraph _m 8344
    digraph _n 8345
    digraph _o 8338
    digraph _p 8346
    digraph _r 7523
    digraph _s 8347
    digraph _t 8348
    digraph _u 7524
    digraph _v 7525
    digraph _x 8339

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
    digraph bR 8477 " conflict: Ⅺ
    digraph bS 120138
    digraph bT 120139
    digraph bU 120140
    digraph bV 120141
    digraph bW 120142
    digraph bX 120143
    digraph bY 120144
    digraph bZ 8484

    digraph sA 120016
    digraph sB 120017 " conflict: ▪
    digraph sC 120018
    digraph sD 120019
    digraph sE 120020
    digraph sF 120021
    digraph sG 120022
    digraph sH 120023
    digraph sI 120024
    digraph sJ 120025
    digraph sK 120026
    digraph sL 120027
    digraph sM 120028
    digraph sN 120029
    digraph sO 120030
    digraph sP 120031
    digraph sQ 120032
    digraph sR 120033
    digraph sS 120034
    digraph sT 120035
    digraph sU 120036
    digraph sV 120037
    digraph sW 120038
    digraph sX 120039
    digraph sY 120040
    digraph sZ 120041

    unmap! <C-Space>
    noremap! <C-Space> <C-k>
    return ''
endfunction

" https://github.com/neovim/neovim/pull/13883
" Redraw is buggy in vim?
" if exists('*setcellwidths')
"     call setcellwidths([[9711, 9711, 2]]) " ◯
" endif

noremap! <silent> <C-Space> <C-R>=<SID>SetupDigraph()<CR><C-K>
