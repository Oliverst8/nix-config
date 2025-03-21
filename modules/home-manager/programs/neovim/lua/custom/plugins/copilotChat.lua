return {
  'CopilotC-Nvim/CopilotChat.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
    { 'zbirenbaum/copilot.lua' },
  },
  opts = {
    -- Add any configuration options here
    window = {
      -- How to open the chat window
      layout = 'float',
      -- Other window options
      border = 'single', -- 'none' | 'single' | 'double' | 'rounded' | 'solid' | 'shadow'
      title = ' Copilot Chat ',
      width = 0.8, -- fractional width of parent window (number between 0 and 1)
      height = 0.6, -- fractional height of parent window (number between 0 and 1)
    },
    -- ... other configuration options
  },
  -- The plugin is already installed via Nix, so we don't need to add a build step
  cmd = {
    'CopilotChat',
    'CopilotChatToggle',
    'CopilotChatOpen',
    'CopilotChatClose',
  },
  keys = {
    -- Add keymaps for quick access
    { '<leader>cc', '<cmd>CopilotChat<CR>', desc = 'CopilotChat - Open' },
    { '<leader>ct', '<cmd>CopilotChatToggle<CR>', desc = 'CopilotChat - Toggle' },
  },
}
