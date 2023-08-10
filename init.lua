require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'morhetz/gruvbox'
  use 'neovim/nvim-lspconfig'
  use { 'mhartington/formatter.nvim' }
  use 'AlessandroYorba/Alduin'
  use 'EdenEast/nightfox.nvim'
  use {
  'nvim-telescope/telescope.nvim', tag = '0.1.1',
-- or                            , branch = '0.1.x',
  requires = { {'nvim-lua/plenary.nvim'} },
  use 'ThePrimeagen/harpoon',
  use 'nvim-treesitter/nvim-treesitter'
}
end)
local lspconfig = require('lspconfig')
lspconfig.gopls.setup {}
lspconfig.clangd.setup {}
vim.highlight.priorities.semantic_tokens = 95
vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "cpp", "c", "go", "rust" },
  auto_install = false,
  highlight = { 
    enable = true,

    disable = function(lang, buf)
      local max_filesize = 1 * 1024 * 1024
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  }
}
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
