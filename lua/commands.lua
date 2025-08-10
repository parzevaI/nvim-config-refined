local utils = require("utils")


-- CUSTOM COMMANDS -------------------------

-- delete all buffers except the currently displayed ones
-- :ClearBuffers       -> delete unshown buffers, keep modified ones
-- :ClearBuffers!      -> force delete, even if modified
vim.api.nvim_create_user_command(
    "ClearBuffers",
    function(opts)
        local force = opts.bang or false
        require("utils").delete_invisible_buffers(force)
    end,
    { bang = true }
)

-- open current directory in warp
vim.api.nvim_create_user_command(
    "Warp",
    function()
        vim.fn.system('open -a Warp .')
    end,
    {}
)

-- create react component
-- add support for common components like "VisuallyHidden" (or just put that in the skeleton)
vim.api.nvim_create_user_command(
    "NewComponent",
    function(opts)
        local name = utils.firstToUpper(opts.fargs[1])
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
local zenModeEnabled = false
local saved_settings = {}

vim.api.nvim_create_user_command(
    "ToggleZen",
    function()
        zenModeEnabled = not zenModeEnabled
        
        if zenModeEnabled then
            print('🧘 Zen mode enabled 🧘')
            
            -- Save current settings
            saved_settings.laststatus = vim.opt.laststatus:get()
            saved_settings.signcolumn = vim.opt.signcolumn:get()
            saved_settings.foldcolumn = vim.opt.foldcolumn:get()
            saved_settings.colorcolumn = vim.opt.colorcolumn:get()
            
            -- Hide UI elements
            vim.opt.laststatus = 0      -- hide statusline
            vim.opt.signcolumn = 'no'   -- hide sign column
            vim.opt.foldcolumn = '0'    -- hide fold column
            vim.opt.colorcolumn = ''    -- hide color column
            
            -- Disable format on save
            saved_settings.conform_format_on_save = vim.g.conform_format_on_save
            vim.g.conform_format_on_save = false
            
            -- Disable blink completion
            saved_settings.completeopt = vim.opt.completeopt:get()
            vim.opt.completeopt = ''
            
            -- Save and disable completion-related autocmds
            vim.cmd('autocmd! CompleteDone')
            vim.cmd('autocmd! TextChangedI')
            vim.cmd('autocmd! TextChangedP')
            
        else
            print('🚨 Zen mode disabled 🚨')
            
            -- Restore saved settings
            vim.opt.laststatus = saved_settings.laststatus or 3
            vim.opt.signcolumn = saved_settings.signcolumn or 'yes'
            vim.opt.foldcolumn = saved_settings.foldcolumn or '0'
            vim.opt.colorcolumn = saved_settings.colorcolumn or ''
            
            -- Restore format on save
            vim.g.conform_format_on_save = saved_settings.conform_format_on_save
            
            -- Restore completion settings
            if saved_settings.completeopt then
                vim.opt.completeopt = saved_settings.completeopt
            end
            
            -- Re-source the completion config to restore autocmds
            vim.schedule(function()
                pcall(vim.cmd, 'doautocmd User BlinkCmpReload')
            end)
        end
    end,
    {}
)
