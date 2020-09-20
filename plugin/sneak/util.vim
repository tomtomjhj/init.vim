" Maybe this is the only way to override autoload function. `:runtime` doesn't
" register the file as autoload file (?), so the file will be sourced again.
" https://groups.google.com/g/vim_dev/c/k9wRhNMNIFc/m/vpFvud0mo9UJ?pli=1
call sneak#util#strlen('')

func! sneak#util#getc() abort
  let c = getchar()
  " hijack <C-q>
  return type(c) == type(0)
              \ ? (c == 17 ? "\<Esc>" : nr2char(c))
              \ : c
endf
