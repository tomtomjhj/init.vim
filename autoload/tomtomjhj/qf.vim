function tomtomjhj#qf#compare_quickfix_item(a, b)
  if a:a.filename < a:b.filename
    return -1
  elseif a:a.filename ==# a:b.filename
    let sub_lnum = str2nr(a:a.lnum) - str2nr(a:b.lnum)
    return sub_lnum ? sub_lnum : str2nr(a:a.col) - str2nr(a:b.col)
  else
    return 1
  endif
endfunction
