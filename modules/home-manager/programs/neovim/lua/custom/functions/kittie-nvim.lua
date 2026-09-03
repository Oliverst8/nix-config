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
  local cmd = 'kittie submit -y'
  cmd = problem_folder == '' and cmd or (cmd .. ' ' .. problem_folder)
  vim.notify 'Submitting problem'
  local handle = io.popen(cmd)
  local result = handle:read '*a'
  handle:close()
  vim.notify(result)
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
