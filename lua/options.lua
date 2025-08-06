require "nvchad.options"


-- GENERAL SETTINGS ------------------------
-- set font
vim.opt.guifont = "Maple\\ Mono\\ NF"

-- set nowrap
vim.opt.wrap = false

-- set relativenumber
vim.opt.relativenumber = true

-- set tab width
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- set color for eyeliner plugin (f/F, t/T movement)
vim.api.nvim_set_hl(0, 'EyelinerPrimary', { fg = "#FFFFFF" })
vim.api.nvim_set_hl(0, 'EyelinerSecondary', { fg = "#F7B5B5" })


-- CUSTOM COMMANDS -------------------------
-- create react component
-- add support for common components like "VisuallyHidden" (or just put that in the skeleton)
vim.api.nvim_create_user_command(
    "NewComponent",
    function(opts)
        local function firstToUpper(str)
            return (str:gsub("^%l", string.upper))
        end
        local name = firstToUpper(opts.fargs[1])
        local config = vim.fn.stdpath("config")

        -- check if component exists
        if vim.fn.filereadable('./src/components/' .. name .. '/' .. name .. '.jsx') == 0 then
            -- copy template directory
            vim.cmd("silent !cp -R " .. config .. '/lua/configs/react-component-template ./src/components/')
            -- rename directory
            vim.cmd("silent !mv ./src/components/react-component-template ./src/components/" .. name)
            -- rename .jsx file
            vim.cmd("silent !mv ./src/components/" .. name .. "/NAME.jsx ./src/components/" .. name .. "/" ..
            name .. ".jsx")
            -- replace component name in all files
            vim.cmd("silent !find ./src/components/" .. name .. "/ -type f | xargs sed -i '' 's/NAME/" .. name .. "/g' ")
            -- print success message
            print("\n\n✨ Creating the " .. name .. " component ✨")
            print("\nDirectory:   src/components/" .. name)
            print("Language:    Javascript XML")
            print("========================================")
            print("\n\n✔︎ Directory created.")
            print("✔︎ Component built and saved to disk.")
            print("✔︎ Index file built and saved to disk.")
            print("\n\nComponent created!\n\n")
        else
            print("\n\nThe " .. name .. " component already exists.\n\n")
        end
    end,
    { nargs = 1 }
)


-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
