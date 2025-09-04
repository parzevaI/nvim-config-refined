require "nvchad.autocmds"


-- AUTOCOMMANDS ------------------------------

-- automatically set tab width based on filetype
-- 2 spaces for markup/web files, 4 spaces for others
local function auto_set_tab_width()
    local ft = vim.bo.filetype
    
    -- Skip for certain special filetypes where tab width doesn't matter
    local skip_filetypes = {
        "help", "startify", "dashboard", "packer", "nerdtree", "fugitive",
        "gitcommit", "git", "TelescopePrompt", "neo-tree", ""
    }
    
    for _, skip_ft in ipairs(skip_filetypes) do
        if ft == skip_ft then
            return
        end
    end
    
    -- Define markup/web filetypes that should use 2-space indentation
    local markup_filetypes = {
        "html", "xml", "css", "scss", "sass", "less",
        "javascript", "typescript", "jsx", "tsx", "js", "ts",
        "json", "yaml", "yml", "markdown", "md",
        "vue", "svelte", "astro"
    }
    
    -- Check if current filetype is a markup/web filetype
    local is_markup = false
    for _, markup_ft in ipairs(markup_filetypes) do
        if ft == markup_ft then
            is_markup = true
            break
        end
    end
    
    -- Set tab width based on filetype category
    local tab_width = is_markup and 2 or 4
    
    -- Apply the tab width settings
    vim.opt.tabstop = tab_width
    vim.opt.shiftwidth = tab_width
    vim.opt.softtabstop = tab_width
end

local group = vim.api.nvim_create_augroup("AutoTabWidth", { clear = true })

vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile"}, {
    group = group,
    callback = function()
        auto_set_tab_width()
    end,
    desc = "Auto-set tab width based on filetype when opening files (2 for markup/web, 4 for others)"
})
