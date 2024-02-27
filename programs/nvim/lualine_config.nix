{config, ...}:
with config.colorScheme.colors; ''
  require('lualine').setup {
  	options = { theme = 'base16' }
  }
''
