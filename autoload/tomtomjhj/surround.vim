" NOTE: 8.2.3619 supports funcref/lambda for operatorfunc
function! tomtomjhj#surround#(type, ends) abort
    if a:type ==# 'char'
        let cmd_x = '`[v`]x'
    elseif a:type ==# 'line'
        let cmd_x = "'[V']vg_x"
    else
        return
    endif

    let sel_save = &selection
    let reg_save = exists('*getreginfo') ? getreginfo('"') : getreg('"')
    let cb_save = &clipboard

    try
        " handle the cursor on eol
        let l:p = (col([line("']"), "$"]) - col("']") <= 1) ? 'p' : 'P'
        set clipboard= selection=inclusive
        silent exe 'noautocmd keepjumps normal!' cmd_x
        call setreg('"', a:ends.getreg('"').a:ends)
        silent exe 'noautocmd keepjumps normal!' l:p
    finally
        call setreg('"', reg_save)
        let &clipboard = cb_save
        let &selection = sel_save
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
