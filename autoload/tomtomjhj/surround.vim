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

function! tomtomjhj#surround#strong(type)
    if a:type == ''
        set opfunc=tomtomjhj#surround#strong
        return 'g@'
    endif
    return tomtomjhj#surround#(a:type, '**')
endfunction

function! tomtomjhj#surround#strike(type)
    if a:type == ''
        set opfunc=tomtomjhj#surround#strike
        return 'g@'
    endif
    return tomtomjhj#surround#(a:type, '~~')
endfunction
