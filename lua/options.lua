require "nvchad.options"
require "commands" -- load custom commands


-- GENERAL SETTINGS ------------------------
-- set font
vim.opt.guifont = "Maple\\ Mono\\ NF"

-- set nowrap
vim.opt.wrap = false

-- set relativenumber
vim.opt.relativenumber = true

-- set tab width
local tabWidth = 4 -- default 4
vim.opt.tabstop = tabWidth
vim.opt.shiftwidth = tabWidth
vim.opt.softtabstop = tabWidth
vim.opt.expandtab = true

-- set color for eyeliner plugin (f/F, t/T movement)
vim.api.nvim_set_hl(0, 'EyelinerPrimary', { fg = "#FFFFFF" })
vim.api.nvim_set_hl(0, 'EyelinerSecondary', { fg = "#F7B5B5" })

-- highlights the line the cursor is on
vim.o.cursorlineopt = 'both' -- to enable cursorline!


