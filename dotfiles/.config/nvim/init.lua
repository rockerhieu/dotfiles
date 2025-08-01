-- Neovim configuration
-- Migrated from vim to nvim for modern editing experience

-- General settings
vim.opt.number = true              -- Show line numbers
vim.opt.relativenumber = true      -- Show relative line numbers
vim.opt.clipboard = 'unnamedplus'  -- Use system clipboard
vim.opt.mouse = 'a'               -- Enable mouse support
vim.opt.ignorecase = true         -- Case insensitive searching
vim.opt.smartcase = true          -- Smart case sensitivity
vim.opt.wrap = false              -- Don't wrap lines
vim.opt.scrolloff = 8             -- Keep 8 lines visible when scrolling
vim.opt.sidescrolloff = 8         -- Keep 8 columns visible when scrolling
vim.opt.cursorline = true         -- Highlight current line
vim.opt.termguicolors = true      -- Enable 24-bit RGB colors

-- Indentation
vim.opt.tabstop = 2               -- Tab width
vim.opt.shiftwidth = 2            -- Indentation width
vim.opt.expandtab = true          -- Use spaces instead of tabs
vim.opt.smartindent = true        -- Smart indentation
vim.opt.autoindent = true         -- Auto indentation

-- Search settings
vim.opt.hlsearch = true           -- Highlight search results
vim.opt.incsearch = true          -- Incremental search

-- File handling
vim.opt.swapfile = false          -- Don't create swap files
vim.opt.backup = false            -- Don't create backup files
vim.opt.writebackup = false       -- Don't create backup before writing
vim.opt.undofile = true           -- Enable persistent undo
vim.opt.undodir = vim.fn.expand('~/.config/nvim/undo')

-- Create undo directory if it doesn't exist
vim.fn.system('mkdir -p ' .. vim.fn.expand('~/.config/nvim/undo'))

-- Key mappings
vim.g.mapleader = ','             -- Set leader key
vim.g.maplocalleader = '\\'       -- Set local leader key

-- Clear search highlighting with Esc
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>', { silent = true })

-- Better window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { silent = true })

-- Move lines up/down
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { silent = true })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { silent = true })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { silent = true })

-- Better indenting in visual mode
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Colorscheme (will fall back gracefully if not installed)
pcall(function()
  vim.cmd('colorscheme solarized')
end)

-- Auto commands
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
  group = 'YankHighlight',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })
  end,
})

-- Remove trailing whitespace on save
augroup('TrimWhitespace', { clear = true })
autocmd('BufWritePre', {
  group = 'TrimWhitespace',
  pattern = '*',
  command = '%s/\\s\\+$//e',
})

-- Auto-create directories when saving files
augroup('AutoCreateDir', { clear = true })
autocmd('BufWritePre', {
  group = 'AutoCreateDir',
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- File type specific settings
augroup('FileTypeSettings', { clear = true })
autocmd('FileType', {
  group = 'FileTypeSettings',
  pattern = { 'javascript', 'typescript', 'json', 'html', 'css', 'yaml' },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

autocmd('FileType', {
  group = 'FileTypeSettings',
  pattern = { 'python', 'rust', 'go' },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- Status line (simple built-in)
vim.opt.statusline = '%f %m %r %h %w [%Y] [%{&ff}] %=%l,%c %p%%'
vim.opt.laststatus = 2

print("Neovim configuration loaded successfully!")