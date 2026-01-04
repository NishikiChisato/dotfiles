-- show cursor line only in active window
vim.api.nvim_create_autocmd({"InsertLeave", "WinEnter"}, {
	callback = function()
    if vim.w.auto_cursorline then
      -- Window-scoped variables for the current window
      vim.w.auto_cursorline = false
      -- Window-scoped options for the current window
      vim.wo.cursorline = true
    end
  end
})

vim.api.nvim_create_autocmd({"InsertEnter", "WinLeave"}, {
	callback = function()
    -- Reverse options
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    end
  end
})
