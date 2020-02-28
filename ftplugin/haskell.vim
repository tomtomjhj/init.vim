setlocal shiftwidth=2 tabstop=2

nnoremap <silent><buffer><leader>is :InteroStart<CR>
nnoremap <silent><buffer><leader>ik :InteroKill<CR>
nnoremap <silent><buffer><leader>io :InteroOpen<CR>
nnoremap <silent><buffer><leader>ih :InteroHide<CR>
nnoremap <silent><buffer><leader>wr :w \| :InteroReload<CR>
nnoremap <silent><buffer><leader>il :InteroLoadCurrentModule<CR>
nnoremap <silent><buffer><leader>if :InteroLoadCurrentFile<CR>
noremap  <silent><buffer><leader>t <Plug>InteroGenericType
noremap  <silent><buffer><leader>T <Plug>InteroType
nnoremap <silent><buffer><leader>ii :InteroInfo<CR>
nnoremap <silent><buffer><leader>it :InteroTypeInsert<CR>
nnoremap <silent><buffer><leader>jd :InteroGoToDef<CR>
nnoremap <buffer><leader>ist :InteroSetTargets<SPACE>
