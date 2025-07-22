" NOTE: 8.2.3619 supports funcref/lambda for operatorfunc
function! tomtomjhj#surround#(type, surrounding) abort
    let start_line = line("'[")
    let end_line = line("']")
    let start_line_text = getline(start_line)
    let end_line_text = getline(end_line)

    " end_byte: exclusive
    if a:type ==# 'char'
        let start_byte = col("'[") - 1
        let end_char_charidx = charcol("']") - 1
        let end_byte = len(strcharpart(end_line_text, 0, end_char_charidx + 1))
    elseif a:type ==# 'line'
        let start_byte = match(start_line_text, '\S')
        if start_byte < 0 | return | endif
        let end_byte = col([end_line, '$']) - 1
    else
        return
    endif

    if has('nvim')
        let ns = nvim_create_namespace('tomtomjhj#surround')
        let end_mark = nvim_buf_set_extmark(0, ns, end_line-1, end_byte, {})
        call nvim_buf_set_text(0, start_line-1, start_byte, start_line-1, start_byte, [a:surrounding])
        let [end_row, end_byte] = nvim_buf_get_extmark_by_id(0, ns, end_mark, {})
        call nvim_buf_clear_namespace(0, ns, 0, -1)
        call nvim_buf_set_text(0, end_row, end_byte, end_row, end_byte, [a:surrounding])
    else
        " NOTE: only works for surrounding without newline
        if start_line == end_line
            let left = strpart(start_line_text, 0, start_byte)
            let surrounded = strpart(start_line_text, start_byte, end_byte - start_byte)
            let right = strpart(start_line_text, end_byte)
            let updated = left . a:surrounding . surrounded . a:surrounding . right
            call setline(start_line, updated)
        else
            let start_left = strpart(start_line_text, 0, start_byte)
            let start_surrounded = strpart(start_line_text, start_byte)
            let start_updated = start_left . a:surrounding . start_surrounded
            let end_surrounded = strpart(end_line_text, 0, end_byte)
            let end_right = strpart(end_line_text, end_byte)
            let end_updated = end_surrounded . a:surrounding . end_right
            call setline(start_line, start_updated)
            call setline(end_line, end_updated)
        endif
    endif
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
