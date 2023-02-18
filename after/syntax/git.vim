" try not to match removed `--` comment (Haskell, Lua, ..)
" NOTE: I put this in this file instead of after/syntax/diff.vim
" despite that syntax/git.vim syn-includes syntax/diff.vim, because
" - for unknown reason diffOldFile is not cleared by that (maybe some bug/feature in syn-include)
" - it's not correct for general diff https://www.gnu.org/software/diffutils/manual/html_node/Detailed-Unified.html
if search('^@@ -\S\+ +\S\+ @@', 'nw', '', 100)
  syn clear diffOldFile
  syn match diffOldFile	"^--- \w/.*" contained
endif
