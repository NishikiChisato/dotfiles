require "lunavim.config.options"
require "lunavim.config.keymaps".load_defaults()

_G.LunaVim = {}
_G.LunaVim.icons = require "lunavim.config.icons"
local util = require "lunavim.util"

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

