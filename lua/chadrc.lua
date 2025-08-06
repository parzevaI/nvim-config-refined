-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

-- themes
M.base46 = {
    theme = "aylin",

    -- hl_override = {
    -- 	Comment = { italic = true },
    -- 	["@comment"] = { italic = true },
    -- },
}

-- ui
M.ui = {
    theme = "ashes",
    -- transparency = true, -- uncomment for terminal emulators

    -- tabs
    tabufline = {
        order = { "treeOffset", "buffers", "tabs" }
    },

    -- bar at the bottom
    statusline = {
        theme = "vscode_colored",
        separator_style = "round",
        overriden_modules = nil,
    },

    -- italic comments
    hl_override = {
        Comment = { italic = true },
        ["@comment"] = { italic = true },
    },
}

-- remove dashboard
M.nvdash = { load_on_startup = false }


return M
