-- Translates cryptic TypeScript compiler errors into plain English.
-- Sourced via flake input "plugins-ts-error-translator" (not in nixpkgs).
return {
  'dmmulroy/ts-error-translator.nvim',
  ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  config = function()
    require('ts-error-translator').setup {
      auto_override_publish_diagnostics = true,
    }
  end,
}
