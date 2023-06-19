require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'morhetz/gruvbox'
  use { 'mhartington/formatter.nvim' }
  use 'AlessandroYorba/Alduin'
  use 'EdenEast/nightfox.nvim'
  use 'savq/melange'
  use ({ 'projekt0n/github-nvim-theme', tag = 'v0.0.7' })
  use {
  'nvim-telescope/telescope.nvim', tag = '0.1.1',
-- or                            , branch = '0.1.x',
  requires = { {'nvim-lua/plenary.nvim'} },
  use { 'nmac427/guess-indent.nvim' },
  use 'ThePrimeagen/harpoon',
  use 'nvim-treesitter/nvim-treesitter',
  use 'mbledkowski/neuleetcode.vim'
}
end)
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "cpp" },
  auto_install = false,
  highlight = { enable = false }
}
require('guess-indent').setup {}
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<S-e>', builtin.grep_string, {})
vim.keymap.set('n', '<S-F>', builtin.treesitter, {})

local hp = require('harpoon.mark')
local hpui = require('harpoon.ui')
vim.keymap.set('n', '<leader>q', hp.add_file, {})
vim.keymap.set('n', '<leader>e', hpui.toggle_quick_menu, {})
vim.keymap.set('n', '<A-q>', hpui.nav_prev, {})
vim.keymap.set('n', '<A-e>', hpui.nav_next, {})

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    -- Formatter configurations for filetype "lua" go here
    -- and will be executed in order
    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
    ["cpp"] = {
      require("formatter.filetypes.cpp").clangformat
    }
  }
}
function file_exists(name)
   local f = io.open(name, "r")
   return f ~= nil and io.close(f)
end


if file_exists(".clang-format") then
vim.cmd [[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost * FormatWrite
augroup END
]]
end

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.nu = true
vim.o.rnu = true
vim.o.swapfile = false 
vim.o.splitright = true
vim.o.guifont = "Noto Sans Mono SemiCondensed:h11"

vim.g.gruvbox_contrast_dark = "hard"
vim.g.gruvbox_bold = 0
vim.g.gruvbox_italic = 0
vim.cmd.colorscheme('gruvbox')
vim.cmd [[set cinoptions=l1]]

function build_debug()
  vim.cmd{cmd = 'vsplit', args = { 'term://powershell cmake --build build' } }
end

function run_debugger()
  vim.cmd{cmd = 'vsplit', args = { 'term://powershell ./debug.rdbg' } }
end

vim.cmd.command('BuildAndTest vs | ter cmake --build build&&ctest --test-dir build')
vim.cmd.command('Build vs | ter cmake --build build')
vim.cmd.command('BuildRelease vs | ter cmake --build build --config Release')
vim.cmd.command('CMakeConfig vs | ter cmake -B build')
vim.cmd.command('CMakeConfigNinja vs | ter cmake -B build -G"Ninja Multi-Config"')
vim.keymap.set('n', '<F5>', build_debug)
vim.keymap.set('n', '<A-F5>', run_debugger)

vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})
