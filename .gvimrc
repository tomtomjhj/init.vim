if has('win32')
    set guifont=Source_Code_Pro:h11:cANSI:qDRAFT
elseif has('unix')
    set guifont=Source\ Code\ Pro\ 13
endif
set guicursor+=a:blinkon0

" <C-->, <C-+> doesn't work even on gvim..
command! -nargs=1 FontSize let &guifont = substitute(&guifont, '\d\+', '\=eval(submatch(0)+<args>)', 'g')
