if !has('nvim')
    finish
endif

augroup NvimStuff | au!
    au TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END
