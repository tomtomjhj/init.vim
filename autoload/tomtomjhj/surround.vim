" NOTE: 8.2.3619 supports funcref/lambda for operatorfunc
function! tomtomjhj#surround#(type, surrounding) abort
    if a:type ==# 'char'
        let cmd_sel = '`[v`]'
    elseif a:type ==# 'line'
        let cmd_sel = "'[V']vg_"
    else
        return
    endif

    let sel_save = &selection
    let reg_save = exists('*getreginfo') ? getreginfo('"') : getreg('"')
    let ve_save = [&l:virtualedit, &g:virtualedit]
    let cb_save = &clipboard
    let visual_save = [getpos("'<"), getpos("'>")]

    " NOTE: '[, '], '<, '> are difficult to work with.
    try
        set clipboard= selection=inclusive ve=
        silent exe 'noautocmd keepjumps normal!' cmd_sel
        let end_eol_col = col([line("."), "$"])
        let end_line_empty = end_eol_col == 1
        " if cursor is on the last char or eol of non-empty line,
        " x moves the resulting cursor from eol to the last char, so use p
        let p = (end_eol_col - col(".") <= 1 && !end_line_empty) ? 'p' : 'P'
        silent exe 'noautocmd keepjumps normal! x'
        let surrounded = a:surrounding
        if end_line_empty
            " put the closer before the newline of empty line
            let surrounded .= getreg('"')[:-2] . a:surrounding . getreg('"')[-1:]
        else
            let surrounded .= getreg('"') . a:surrounding
        endif
        call setreg('"', surrounded)
        silent exe 'noautocmd keepjumps normal!' p
    finally
        call setreg('"', reg_save)
        let &clipboard = cb_save
        let &selection = sel_save
        let [&l:virtualedit, &g:virtualedit] = ve_save
        call setpos("'<", visual_save[0])
        call setpos("'>", visual_save[1])
    endtry
endfunction

function! tomtomjhj#surround#strong(type) abort
    if a:type == ''
        set opfunc=tomtomjhj#surround#strong
        return 'g@'
    endif
    return tomtomjhj#surround#(a:type, '**')
endfunction

function! tomtomjhj#surround#strike(type) abort
    if a:type == ''
        set opfunc=tomtomjhj#surround#strike
        return 'g@'
    endif
    return tomtomjhj#surround#(a:type, '~~')
endfunction

" nest = 0: Don't consider nesting.
" nest > 0: Select nest-th surround.
function! tomtomjhj#surround#textobj(open, close, nest) abort
    " searchpair()'s 'c' flag matches both start and end.
    " Append '\zs' to the closer pattern so that it doesn't match the closer on the cursor.
    let found = searchpair(a:open, '', a:close.'\zs', 'bcW')
    if found <= 0
        return
    endif
    if a:nest > 0
        for _ in range(a:nest - 1)
            let found = searchpair(a:open, '', a:close, 'bW')
            if found <= 0
                return
            endif
        endfor
    endif
    norm! v
    if a:nest is# 0
        call search(a:open, 'ceW')
        let found = search(a:close, 'eW')
    else
        let found = searchpair(a:open, '', a:close, 'W')
        call search(a:close, 'ceW')
    endif
    if found <= 0
        exe "norm! \<Esc>"
    endif
endfunction
