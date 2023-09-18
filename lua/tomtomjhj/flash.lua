local flash = require('flash')

-- TODO
-- * forced-motion to V? Should use mode(1) to decide the type of operator pending mode
-- * nohlsearch while getting chars?
-- * jump()
--   * can't distinguish multiple window showing the same part of the buffer
-- * char (f,F,t,T)
--   * highlight is different from jump()
--   * nmap
--     * after execution, f behaves like clever-f. maybe fixed.
--       user may want to use f with different char
--   * omap
--     * should terminate after execution of 'd' operator
--     * dot-repeating {operator}f{char} is weird
-- * treesitter()
--   * don't map if parser not available
--   * namp
--     * use <M-;> to decrease
--   * omap
--     * if <Esc>-ed, then shouldn't execute 'c' operator
--   * after "fix(treesitter): include treesitter injections. Fixes #242", cannot climb up the injection.
--     Makes markdown unusable.
--     This happens because `tree_for_range` returns child tree, but there is not way to climb up to the injecting tree.

flash.setup {
  modes = {
    search = { enabled = false, },
    char = { enabled = false, },
  },
  prompt = { enabled = false },
}

for _, map in ipairs {
  { { "n", "o", "x" }, "<M-s>", function() flash.jump() end, },
  { { "n", "o", "x" }, "M",     function() flash.treesitter() end, },
  -- { "o",               "r",     function() flash.remote() end, },
  { { "o", "x" },      "R",     function() flash.treesitter_search() end, },
  { { "c" },           "<C-s>", function() flash.toggle() end, },
} do
  vim.keymap.set(unpack(map))
end
