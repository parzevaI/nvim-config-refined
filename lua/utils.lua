local M = {}

function M.firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function M.move_or_create_win(key)
    local fn = vim.fn
    local curr_win = fn.winnr()
    vim.cmd("wincmd " .. key)        --> attempt to move

    if (curr_win == fn.winnr()) then --> didn't move, so create a split
        if key == "h" or key == "l" then
            vim.cmd("wincmd v")
        else
            vim.cmd("wincmd s")
        end

        vim.cmd("wincmd " .. key)
    end
end

function M.runfile(file)
    local filetype = file:match("%.([%w_]+)$")

    local commands = {
        py = function(filepath) return "python3 " .. filepath end,

        js = function(filepath) return "node " .. filepath end,

        ts = function(filepath) return "node " .. filepath end,

        html = function(filepath) return "open " .. filepath end,

        swift = function(filepath)
            local filename = string.match(filepath, "[^/]+$"):sub(1, -7)
            return "(swiftc " .. filepath .. " && ./" .. filename .. ")"
        end,

        rs = function(filepath)
            local uv = vim.loop
            local fn = vim.fn

            local function abspath_dir(path)
                -- Resolve to absolute path of the file's directory
                return fn.fnamemodify(path, ":p:h")
            end

            local function find_cargo_root(start_dir)
                local curr = uv.fs_realpath(start_dir) or start_dir
                while curr do
                    if uv.fs_stat(curr .. "/Cargo.toml") then
                        return curr
                    end
                    -- Stop at filesystem root
                    local parent = curr:match("(.+)/[^/]+$")
                    if not parent or parent == curr then
                        break
                    end
                    curr = parent
                end
                return nil
            end

            local filedir = abspath_dir(filepath)
            local cargo_root = find_cargo_root(filedir)

            if cargo_root then
                return "(builtin cd \"" .. cargo_root .. "\" && cargo run --quiet)"
            else
                local filename = string.match(filepath, "[^/]+$"):sub(1, -4)
                return "(rustc " .. filepath .. " && ./" .. filename .. ")"
            end
        end,

        lua = function(filepath) return "lua " .. filepath end,

        java = function(filepath)
            local filename = string.match(filepath, "[^/]+$"):sub(1, -6)
            local filedir = filepath:sub(1, filepath:match(".+()/"))
            -- return "(cd "..filedir.." && javac "..filepath.." && java "..filename..")"
            return "(javac " .. filepath .. " && java " .. filename .. ")"
        end,

        svelte = function(filepath)
            local filedir = filepath:sub(1, filepath:match(".+()/"))
            return "(builtin cd \"" .. filedir .. "\" && npm run dev)"
        end,
    }

    require("nvchad.term").runner {
        pos = "float",
        cmd = commands[filetype](file),
        id = "floatTerm",
        clear_cmd = false
    }
end


-- Delete all buffers except those currently displayed in any window (across all tabs)
-- If force is true, modified buffers will also be closed.
function M.delete_invisible_buffers(force)
    local api = vim.api
    local keep = {}

    -- Collect bufnrs from all visible windows across all tabpages
    for _, tab in ipairs(api.nvim_list_tabpages()) do
        for _, win in ipairs(api.nvim_tabpage_list_wins(tab)) do
            local b = api.nvim_win_get_buf(win)
            keep[b] = true
        end
    end

    local deleted, skipped = 0, {}

    for _, buf in ipairs(api.nvim_list_bufs()) do
        local ok_listed = pcall(function()
            return vim.bo[buf].buflisted
        end)
        local listed = ok_listed and vim.bo[buf].buflisted or false

        if listed and not keep[buf] then
            local bt = vim.bo[buf].buftype
            local modified = vim.bo[buf].modified
            -- Skip special buffers
            if bt == "help" or bt == "nofile" then
                goto continue
            end

            if modified and not force then
                table.insert(skipped, buf)
                goto continue
            end

            local ok = pcall(api.nvim_buf_delete, buf, { force = force or false })
            if ok then
                deleted = deleted + 1
            else
                table.insert(skipped, buf)
            end
        end
        ::continue::
    end

    local msg = string.format("Deleted %d buffers", deleted)
    if #skipped > 0 then
        msg = msg .. string.format("; skipped %d (modified or failed)", #skipped)
    end
    print(msg)
end

return M
