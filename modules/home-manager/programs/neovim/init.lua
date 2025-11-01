--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- NOTE: NIXCATS USERS:
-- NOTE: there are also notes added as a tutorial of how to use the nixCats lazy wrapper.
-- you can search for the following string in order to find them:
-- NOTE: nixCats:

-- like this one:
-- NOTE: nixCats: this just gives nixCats global command a default value
-- so that it doesnt throw an error if you didnt install via nix.
-- usage of both this setup and the nixCats command is optional,
-- but it is very useful for passing info from nix to lua so you will likely use it at least once.
require('nixCatsUtils').setup {
  non_nix_value = true,
}

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
-- NOTE: nixCats: we asked nix if we have it instead of setting it here.
-- because nix is more likely to know if we have a nerd font or not.
vim.g.have_nerd_font = nixCats 'have_nerd_font'

-- options
require 'options'

-- keymaps
require 'keymaps'

-- plugins
require 'lazy-plugins'

-- The line beneath this is called `modeline`. See `:help modeline`
--
vim.keymap.set('n', '<leader>he', function()
  print 'Hello, world!'
end, { desc = 'Print Hello World' })

vim.keymap.set('n', '<leader>mp', function()
  local line = vim.api.nvim_get_current_line()
  print('Current line:', line)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  if col >= #line then
    print 'Cursor is past the end of line'
  else
    local char = line:sub(col + 1, col + 1)
    print('Character under cursor:', char)
  end
end, {})

vim.keymap.set('n', 'th', function()
  -- show_letters_above.lua
  local ns = vim.api.nvim_create_namespace 'CharHintsAbove'
  local buf = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  local line = vim.api.nvim_get_current_line()

  -- split into characters (works with multibyte)
  local chars = vim.fn.split(line, '\\zs')
  local length = table.getn(chars)
  local first_half = length / 2

  local label2 = {}
  for i = 1, first_half do
    print(i)
    --table.insert(label2, first_half - i + 1, i)
  end

  -- build one virtual line string with padding equal to each character's display width
  local label = {}
  for i, ch in ipairs(chars) do
    local num
    -- append the letter and pad so it occupies the same display width as the underlying character
    table.insert(label, num)
  end
  local virt_line_text = table.concat(label)

  -- clear previous
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  -- create a single extmark at column 0 with a single virt_lines entry above the line
  vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
    virt_lines = { { { virt_line_text, 'Comment' } } },
    virt_lines_above = true,
    -- ephemeral = true, -- optional on newer Neovim to avoid undo history pollution
  })
end, {})
