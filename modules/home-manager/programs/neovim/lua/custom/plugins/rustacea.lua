return {
  'mrcjkb/rustaceanvim',
  version = '^6', -- Recommended
  lazy = false, -- This plugin is already lazy
  server = {
    default_settings = {
      ['rust-analzyer'] = { diagnostics = {
        enable = true,
      } },
    },
  },
}
