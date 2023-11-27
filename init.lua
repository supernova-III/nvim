require('packer').startup(
  function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use 'morhetz/gruvbox'
    use { 'mhartington/formatter.nvim' }
    use 'AlessandroYorba/Alduin'
    use 'EdenEast/nightfox.nvim'
    use {
      'nvim-telescope/telescope.nvim', tag = '0.1.4',
      requires = { {'nvim-lua/plenary.nvim'} },
    }
  end
)

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<S-e>', builtin.grep_string, {})
vim.keymap.set('n', '<S-F>', builtin.treesitter, {})

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
      require("formatter.filetypes.cpp").clangformat
    },
    ["c"] = {
      require("formatter.filetypes.c").clangformat
    },
    ["go"] = {
      require("formatter.filetypes.go").gofmt
    },
  }
}

function file_exists(name)
   local f = io.open(name, "r")
   return f ~= nil and io.close(f)
end


if file_exists(".clang-format") or file_exists("go.mod") then
vim.cmd [[
inoremap <C-n> <C-x><C-o>
set completeopt-=preview
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
vim.cmd [[set clipboard=unnamedplus]]

vim.cmd.command('Debug vs | ter .\\debug.rdbg')
vim.cmd.command('GoBuild vs | ter go build main.go')
vim.cmd.command('GoRun vs | ter go run main.go')
vim.cmd.command('BuildAndTest vs | ter cmake --build build&&ctest --test-dir build')
vim.cmd.command('Build vs | ter cmake --build build')
vim.cmd.command('BuildRelease vs | ter cmake --build build --config Release')
vim.cmd.command('CMakeConfig vs | ter cmake -B build')
vim.cmd.command('CMakeConfigNinja vs | ter cmake -B build -G"Ninja Multi-Config"')

vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})
