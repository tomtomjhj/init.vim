GuiTabline 0
GuiPopupmenu 0
GuiFont Source Code Pro:h13

func! FontSize(delta)
    let [name, size] = matchlist(g:GuiFont, '\v(.*:h)(\d+)')[1:2]
    let new_size = str2nr(size) + a:delta
    exe 'GuiFont ' . name . new_size
endfunc

map <silent><C--> :<C-u>call FontSize(-v:count1)<CR>
map <silent><C-+> :<C-u>call FontSize(v:count1)<CR>
map <silent><C-=> :<C-u>call FontSize(v:count1)<CR>
