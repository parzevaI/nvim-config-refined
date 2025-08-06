require "nvchad.options"


-- GENERAL SETTINGS ------------------------
-- set font
vim.opt.guifont = "Maple\\ Mono\\ NF"

-- set nowrap
vim.opt.wrap = false

-- set relativenumber
vim.opt.relativenumber = true

-- set tab width
local tabWidth = 4
vim.opt.tabstop = tabWidth
vim.opt.shiftwidth = tabWidth
vim.opt.softtabstop = tabWidth
vim.opt.expandtab = true

-- set color for eyeliner plugin (f/F, t/T movement)
vim.api.nvim_set_hl(0, 'EyelinerPrimary', { fg = "#FFFFFF" })
vim.api.nvim_set_hl(0, 'EyelinerSecondary', { fg = "#F7B5B5" })

-- highlights the line the cursor is on
vim.o.cursorlineopt = 'both' -- to enable cursorline!


-- CUSTOM COMMANDS -------------------------
-- create react component
-- add support for common components like "VisuallyHidden" (or just put that in the skeleton)
vim.api.nvim_create_user_command(
    "NewComponent",
    function(opts)
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

-- toggle zen mode
-- DOESNT WORD YET
local zenModeEnabled = false
vim.api.nvim_create_user_command(
    "ToggleZen",
    function()
        if zenModeEnabled then
            -- conform
            vim.g.conform_format_on_save = false

            -- blink
            local new_sources = {}
            for _, source in ipairs(cmp.get_config().sources) do
                if source.name ~= "blink" then
                    table.insert(new_sources, source)
                else
                    blink_cmp_source = source -- store it to re-enable later
                end
            end
            cmp.setup({ sources = new_sources })


            print('Zen mode disabled')
        else
            -- conform
            vim.g.conform_format_on_save = true

            if blink_cmp_source then
                local current_sources = cmp.get_config().sources
                table.insert(current_sources, blink_cmp_source)
                cmp.setup({ sources = current_sources })
            end

            print(' 🧘 Hush, im zenning... zzzZZZZZ')
        end
    end,
    { nargs = 0 }
)
