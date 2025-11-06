require "nvchad.mappings"
local utils = require("utils")

local map = vim.keymap.set


-- faster basic commands
map({ "n", "v" }, ";", ":", { desc = "enter command mode" })
map({ "i", "c" }, "jk", "<ESC>")
map("i", "jj", "<ESC>")



-- NAVIGATION ------------------------------
-- general
map({ "n", "v" }, "j", "gj", { desc = "move down" })
map({ "n", "v" }, "k", "gk", { desc = "move up" })
map({ "n", "v" }, "H", "b", { desc = "move back a word" })
map({ "n", "v" }, "L", "w", { desc = "move forward a word" })
map({ "n", "v" }, "J", "5gj", { desc = "move down more" })
map({ "n", "v" }, "K", "5gk", { desc = "move up more" })
map({ "n", "v" }, "<CR>", "zz", { desc = "center cursor" })

-- text searching
map({ "n", "v" }, "s", "/", { desc = "flash search" })
map({ "n", "v" }, "?", "/", { desc = "search for word" })
map({ "n", "v" }, "*", "*N", { desc = "highlight instances of word under cursor" })
map({ "n", "v" }, "n", "nzz", { desc = "next result" })
map("n", "<leader>re", ":%s/\\<<C-r><C-w>\\>//gcI<Left><Left><Left><Left>", 
    { desc = "search and replace word under cursor"})
map("v", "<leader>re", "y:%s/\\V<C-r>=escape(@\", '/\\')<CR>//gcI<Left><Left><Left><Left>", 
    { desc = "search and replace visual selection"})

-- remap square bracket navigation
-- map({ "n", "v" }, "]d", "]dzz", { desc = "move next diagnostic" })
-- map({ "n", "v" }, "[d", "[dzz", { desc = "move previous diagnostic" })

-- file searching (snacks picker)
map("n", "<leader>fa", function()
    require("snacks").picker.smart()
end, { desc = "Smart Find Files" })

map("n", "<leader>fb,", function()
    require("snacks").picker.buffers()
end, { desc = "Buffers" })

map("n", "<leader>fw", function()
    require("snacks").picker.grep()
end, { desc = "Grep" })

map("n", "<leader>f;", function()
    require("snacks").picker.command_history()
end, { desc = "Command History" })

map("n", "<leader>fn", function()
    require("snacks").picker.notifications()
end, { desc = "Notification History" })

map("n", "e", function()
    require("snacks").explorer()
end, { desc = "File Explorer" })


-- TEXT ------------------------------------
-- text editing
map("n", "U", "<C-r>", { desc = "redo" })
map("n", "gp", "'[V']", { desc = "select last change/paste" })
map("n", "E", "<cmd>TSJToggle<CR>", { desc = "toggle collapsed formatting" })
map("n", "<C-a>", "ggVG", { desc = "select all" }) -- change this to keep cursor in the same location
map("n", "<leader>fy", "<CMD>Telescope neoclip<CR>", { desc = "open yank history" })
map("n", "gs", function()
    require('textcase').current_word('to_snake_case')
end, { desc = "change word to snake case" })
map("n", "dd", function()
    if vim.api.nvim_get_current_line():match("^%s*$") then
        return '"_dd'
    else
        return "dd"
    end
end, { expr = true, desc = "delete line; use blackhole register on empty lines" })
map("v", ".", ":norm .<CR>", { desc = "perform last change on all selected lines" })
-- map("v", "@", ":norm @q<CR>", { desc = "perform q macro on all selected lines" })
map("v", ",", ":norm @q<CR>", { desc = "perform q macro on all selected lines" })
map("v", "g_", "<CMD>s/ /_/g", { desc = "replace spaces with underscores" })
-- map("i", "<C-o>", "<ESC>o", { desc = "add a new line below" }) -- [<space>
-- map("i", "<C-S-O>", "<ESC>O", { desc = "add a new line above" })

-- indenting
map("n", "<tab>", ">>", { desc = "indent" })
map("n", "<S-tab>", "<<", { desc = "unindent" })
map("v", "<tab>", ">gv", { desc = "indent" })
map("v", "<S-tab>", "<gv", { desc = "unindent" })

-- macros
-- map("n", "?", "qu", { desc = "write quick macro" })
map("n", ",", "@q", { desc = "run q macro" })

-- comments
map("n", "/", "<cmd>normal gcc<CR>", { desc = "toggle comment" })
map("v", "/", "<cmd>normal gc<CR>", { desc = "toggle comment" })

-- snippets (luasnip)
map({ "i", "s" }, "<c-l>", function()
    require("luasnip").jump(1)
end, {
    silent = true,
    desc = "forward one selection",
})

map({ "i", "s" }, "<c-h>", function()
    require("luasnip").jump(-1)
end, {
    silent = true,
    desc = "back one selection",
})


-- WINDOWS ---------------------------------
-- file
map("n", "w", ":w<CR>", { desc = "quick save" })
map("n", "<leader>q", ":q<CR>", { desc = "quick quit" })
map("n", "<leader>a", ":qa<CR>", { desc = "quick quit" })
map("n", "g.", ":!open .", { desc = "open current directory in finder" })

-- splits
map("n", "<C-h>", function()
    utils.move_or_create_win("h")
end, { desc = "move or create split left" })

map("n", "<C-l>", function()
    utils.move_or_create_win("l")
end, { desc = "move or create split right" })

map("n", "<C-j>", function()
    utils.move_or_create_win("j")
end, { desc = "move or create split down" })

map("n", "<C-k>", function()
    utils.move_or_create_win("k")
end, { desc = "move or create split up" })

-- buffers
map("n", "<leader>bn", ":enew<CR>", { desc = "new buffer (w <name> to save)" })
map("n", "<leader>bc", ":ClearBuffers<CR>", { desc = "clear all but current buffer" })

-- TERMINAL --------------------------------
map({ "n", "v" }, ":", ":!", { desc = "open terminal command prompt" })
-- you can pipe visual without replacing the visual by writing it first
-- :'<,'>w !python3
map("n", "\\", function()
    require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "open floating terminal" })

map("t", "\\", function()
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_close(win, true)
end, { desc = "close floating terminal" })

map("n", "<Bar>", function()
    utils.runfile(vim.fn.getreg('%'))
end, { desc = "run current file" })

map("t", "<Bar>", function()
    utils.runfile(vim.fn.getreg('#'))
end, { desc = "run current file" })






-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
