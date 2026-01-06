require "lunavim.config.options"
_G.LunaVim = {}
_G.LunaVim.icons = require "lunavim.config.icons"
_G.LunaVim.util = require "lunavim.util"
require "lunavim.config.keymaps".load_defaults()
_G.LunaVim.plugin_keymaps = require "lunavim.config.keymaps".plugin_keymaps

local defaults = require "lunavim.config.keymaps".get_defaults()
local mode_adapter = require "lunavim.config.keymaps".get_adapter()

-- for mode, mappings in pairs(defaults) do
--   local raw_mode = mode_adapter[mode]
--   for k, _ in pairs(mappings) do
--     if util.keymapping_exist(raw_mode, k) then
--       print(("keymap: %s ✅"):format(k))
--     else
--       print(("keymap: %s don't exist"):format(k))
--     end
--   end
-- end

function send_window_to_next_tab()
  local curr_win = vim.api.nvim_get_current_win()
  local curr_buf = vim.api.nvim_get_current_buf()
  local curr_tab = vim.api.nvim_get_current_tabpage()
  local tab_list = vim.api.nvim_list_tabpages()

  local wins_in_tab = vim.api.nvim_tabpage_list_wins(curr_tab)
  if #wins_in_tab / 2 <= 1 then
    return
  end

  local target_tab = nil
  for i, tab in ipairs(tab_list) do
    if tab == curr_tab then
      target_tab = tab_list[i + 1]
      break
    end
  end

  if target_tab then
    vim.api.nvim_set_current_tabpage(target_tab)
    vim.cmd("leftabove vsplit")
    vim.api.nvim_win_set_buf(0, curr_buf)
    vim.api.nvim_set_current_tabpage(curr_tab)
  else
    vim.cmd("tabnew")
    vim.api.nvim_win_set_buf(0, curr_buf)
    vim.api.nvim_set_current_tabpage(curr_tab)
  end

  vim.schedule(function()
    if vim.api.nvim_win_is_valid(curr_win) then
      pcall(vim.api.nvim_win_close, curr_win, false)
    end
  end)
end

vim.keymap.set("n", "<leader>wn", function() send_window_to_next_tab() end, { desc = "" })
