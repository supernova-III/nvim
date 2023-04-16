require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'luisiacc/gruvbox-baby'
  use { 'mhartington/formatter.nvim' }
  use 'AlessandroYorba/Alduin'
  use 'EdenEast/nightfox.nvim'
  use 'savq/melange'
  use {
      'nvim-telescope/telescope.nvim', tag = '0.1.0',
      -- or                            , branch = '0.1.x',
      requires = { {'nvim-lua/plenary.nvim'} }
      }
end)

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  -- Enable or disable logging
  logging = false,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    -- Formatter configurations for filetype "lua" go here
    -- and will be executed in order
    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
    ["cpp"] = {
      -- "formatter.filetypes.any" defines default configurations for any
      -- filetype
      require("formatter.filetypes.cpp").clangformat
    }
  }
}

vim.cmd [[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost * FormatWrite
augroup END
]]

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.nu = true
vim.o.rnu = true
vim.o.swapfile = false 
vim.o.splitright = true
vim.o.guifont = "Cascadia Mono:h10"

vim.g.gruvbox_baby_function_style = "NONE"
vim.g.gruvbox_baby_comment_style = "NONE"
vim.g.gruvbox_baby_keyword_style = "NONE"
vim.g.gruvbox_baby_background_color = "dark"
vim.cmd.colorscheme('terafox')

function build_debug()
  vim.cmd{cmd = 'vsplit', args = { 'term://powershell cmake --build build' } }
end

function run_debugger()
  vim.cmd{cmd = 'vsplit', args = { 'term://powershell ./debug.rdbg' } }
end

vim.keymap.set('n', '<F5>', build_debug)
vim.keymap.set('n', '<A-F5>', run_debugger)
