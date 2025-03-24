return {
  'klen/nvim-config-local',
  config = function()
    require('config-local').setup {
      config_files = { '.nvim.lua', '.nvimrc.lua', '.nvimrc' }, -- List of local config files
      lookup_parents = true, -- Search for config in parent directories
      commands_create = true, -- Create commands (ConfigLocalSource, ConfigLocalEdit, ConfigLocalTrust, ConfigLocalDeny)
      silent = false, -- Show notifications when loading a local config
      hashfile = vim.fn.stdpath 'data' .. '/config-local', -- Store file hashes to prevent repeated prompts
    }
  end,
}
