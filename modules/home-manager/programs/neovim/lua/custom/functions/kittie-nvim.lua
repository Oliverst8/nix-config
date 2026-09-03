-- Your own functions + keymaps, kept separate from kickstart's `keymaps.lua`.
-- Add whatever you want below. Reload without rebuilding: see the wrapRc/
-- unwrappedCfgPath setup in default.nix, then just restart nvim.

local M = {}

function M.hello_world()
  vim.notify 'Hello, world!'
end

local current_problem = 'unchanged'
local cwd = vim.fn.getcwd()
local problem_path = ''
local problem_folder = ''

function M.kittie_get()
  vim.notify('Was: ' .. current_problem)
  vim.ui.input({ prompt = 'Enter problem id: ' }, function(input)
    if input == nil then
      return -- user pressed <Esc>
    end
    vim.notify('Trying to get ' .. input .. ' from <kattis-link>')
    current_problem = input
    --local cwd = vim.fn.getcwd()
    --vim.notify('cwd: ' .. cwd)
    local handle = io.popen('kittie get ' .. input)
    local result = handle:read '*a'
    handle:close()
    vim.notify(result)
    problem_folder = (cwd .. '/' .. input)
    problem_path = (problem_folder .. '/' .. input .. '.py')
    vim.cmd.edit(problem_path)
  end)
end

function M.kittie_submit()
  local cmd = { 'kittie', 'submit', '-y' }
  if problem_folder ~= '' then
    table.insert(cmd, problem_folder)
  end

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = math.floor(vim.o.columns * 0.7),
    height = math.floor(vim.o.lines * 0.4),
    row = math.floor(vim.o.lines * 0.25),
    col = math.floor(vim.o.columns * 0.15),
    style = 'minimal',
    border = 'rounded',
    title = ' Submitting to kattis ',
    title_pos = 'center',
  })

  vim.fn.jobstart(cmd, {
    term = true,
    on_exit = function(_, code)
      if code == 0 then
        vim.notify('Submission accepted', vim.log.levels.INFO)
      else
        vim.notify('kittie exited with ' .. code, vim.log.levels.WARN)
      end
    end,
  })

  vim.keymap.set('n', 'q', function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, { buffer = buf, nowait = true })

  vim.cmd 'startinsert' -- so the terminal scrolls/follows output
end

function M.kittie_test()
  vim.notify 'Kittie test was called'
  local cmd = 'kittie test'
  cmd = problem_path == '' and cmd or (cmd .. ' ' .. problem_folder)
  local handle = io.popen(cmd)
  local result = handle:read '*a'
  handle:close()
  vim.notify(result)
end

vim.keymap.set('n', '<leader>kg', M.kittie_get, { desc = '[K]ittie [G]et' })
vim.keymap.set('n', '<leader>kt', M.kittie_test, { desc = '[K]ittie [T]est' })
vim.keymap.set('n', '<leader>ks', M.kittie_submit, { desc = '[K]ittie [S]ubmit' })

return M
