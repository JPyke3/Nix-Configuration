{config, ...}:
with config.colorScheme.palette; ''
  require('lualine').setup {
  	options = { theme = 'base16' }
  }
''
