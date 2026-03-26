return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {
    settings = {
      -- Show inlay hints for parameter names, types, and return types
      tsserver_file_preferences = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
        -- Include completions for module exports
        includeCompletionsForModuleExports = true,
        -- Import styles
        importModuleSpecifierPreference = 'non-relative',
      },
      -- Expose all TypeScript code actions as LSP code actions
      expose_as_code_action = 'all',
    },
  },
}
