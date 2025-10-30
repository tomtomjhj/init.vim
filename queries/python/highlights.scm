;; extends

; hack: using lsp captures in tree-sitter highlights so that I don't need custom highlight groups
(function_definition
  name: (identifier) @lsp.typemod.function.definition)
(class_definition
  name: (identifier) @lsp.typemod.class.definition)
