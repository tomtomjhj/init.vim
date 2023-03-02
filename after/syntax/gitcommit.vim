" see ./git.vim
if search('^@@ -\S\+ +\S\+ @@', 'nw', '', 100)
  syn clear diffOldFile
  syn match diffOldFile	"^--- \w/.*" contained
endif
