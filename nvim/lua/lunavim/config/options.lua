-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Make line numbers default
vim.o.number = true
-- Make line relative number default
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'
-- Enable mouse movement event
vim.o.mousemoveevent = true

-- We don't need to show the current mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim
-- We need invoke vim.schedule, since we don't hope this behavior breaks something else that Nvim is doing
vim.schedule(function()
	vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Enable undo history
vim.o.undofile = true

-- Case-insensitive earching unless \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Always enable sign column
vim.o.signcolumn = 'yes'

-- Decrease time for swap file saving
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- show the effects of substitutions
vim.o.inccommand = 'split'

-- Show which line the cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor
vim.o.scrolloff = 8

-- Raise a dialog asking if we wish to save the current files
-- vim.o.confirm = true

-- Number of spaes that a <Tab> counts
vim.o.tabstop = 2
-- Number of spaces to use for each step of indent
vim.o.shiftwidth = 2
-- Use a approriate number of spaces to insert a <Tab>
vim.o.expandtab = true
-- Copy indent from current line when starting a new line
vim.o.autoindent = true
