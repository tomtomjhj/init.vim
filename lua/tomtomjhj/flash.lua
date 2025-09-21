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

flash.setup {
  modes = {
    search = { enabled = false, },
    char = { enabled = false, },
  },
  prompt = { enabled = false },
}

return flash
