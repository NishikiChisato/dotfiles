-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Number of spaes that a <Tab> counts
vim.opt.tabstop = 2
-- Number of spaces to use for each step of indent
vim.opt.shiftwidth = 2
-- Use a approriate number of spaces to insert a <Tab>
vim.opt.expandtab = true
-- Copy indent from current line when starting a new line
vim.opt.autoindent = true

-- Make line numbers default
vim.opt.number = true
-- Make line relative number default
vim.opt.relativenumber = true

-- Don't wrap line
vim.opt.wrap = false

-- Enable mouse mode
vim.opt.mouse = 'a'
-- Enable mouse movement event
-- vim.opt.mousemoveevent = true

-- We don't need to show the current mode, since it's already in the status line
vim.opt.showmode = false

-- Stack layout for tags
-- vim.opt.jumpoptions = "stack"

-- Sync clipboard between OS and Neovim
-- We need invoke vim.schedule, since we don't hope this behavior breaks something else that Nvim is doing
vim.schedule(function()
	vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Enable undo history
vim.opt.undofile = true

-- Case-insensitive earching unless \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Always enable sign column
vim.opt.signcolumn = 'yes'

-- Decrease time for swap file saving
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300
vim.opt.ttimeoutlen = 0

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- show the effects of substitutions
vim.opt.inccommand = 'split'

-- Show which line the cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Raise a dialog asking if we wish to save the current files
vim.opt.confirm = true

-- Turm on termguicolors for tokyonight colorscheme to work. must have to use true color terminal
vim.opt.termguicolors = true
-- Background can be "light" or "dark"
vim.opt.background = "dark"
-- Show sign column so that text doesn't shift
vim.opt.signcolumn = "yes"
