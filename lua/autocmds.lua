require "nvchad.autocmds"


-- AUTOCOMMANDS ------------------------------

-- automatically set tab width based on filetype
-- 2 spaces for markup/web files, 4 spaces for others
local markup_filetypes = {
  "html", "xml", "css", "scss", "sass", "less",
  "javascript", "typescript", "javascriptreact", "typescriptreact",
  "json", "yaml", "yml", "markdown",
  "vue", "svelte", "astro",
}

local function set_tab_width_for_current_buffer()
  local ft = vim.bo.filetype

  -- Skip for certain special filetypes where tab width doesn't matter
  local skip = {
    help = true, startify = true, dashboard = true, packer = true, nerdtree = true,
    fugitive = true, gitcommit = true, git = true, TelescopePrompt = true, ["neo-tree"] = true,
  }
  if skip[ft] then return end

  local is_markup = false
  for _, mft in ipairs(markup_filetypes) do
    if ft == mft then
      is_markup = true
      break
    end
  end

  local w = is_markup and 2 or 4
  -- Use buffer-local options so other buffers keep their own widths
  vim.opt_local.tabstop = w
  vim.opt_local.shiftwidth = w
  vim.opt_local.softtabstop = w
  vim.opt_local.expandtab = true
end

local group = vim.api.nvim_create_augroup("AutoTabWidth", { clear = true })

-- Run when filetype is set so we reliably know the buffer's filetype
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "*",
  callback = set_tab_width_for_current_buffer,
  desc = "Set 2-space tabs for markup/web filetypes, 4 for others",
})

-- Apply once on startup for the current buffer in case FileType fired before this file loaded
vim.schedule(set_tab_width_for_current_buffer)
