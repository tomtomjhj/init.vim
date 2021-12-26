" vim-markdown/indent/ does something very weird
setlocal commentstring=<!--%s-->
setlocal comments=s:<!--,m:\ \ \ \ ,e:-->,n:>

setlocal formatlistpat=\\C^\\s*[\\[({]\\\?\\([0-9]\\+\\\|[iIvVxXlLcCdDmM]\\+\\\|[a-zA-Z]\\)[\\]:.)}]\\s\\+\\\|^\\s*[-+o*]\\s\\+
setlocal formatoptions+=n
