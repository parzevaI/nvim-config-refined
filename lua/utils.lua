local M = {}


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
            -- local filename = string.match(filepath, "[^/]+$"):sub(1,-4)
            -- local filedir = filepath:sub(1, filepath:match(".+()/"))
            -- local dir_to_src = filedir:match("(.-)/src")
            -- if dir_to_src then
            --
            --   local handle = io.popen("(cd "..dir_to_src.." && ls)")
            --
            --   if handle then
            --     local is_cargo = string.find(handle:read("*a"), "Cargo.toml")
            --     handle:close()
            --
            --     if is_cargo then
            --       return "(cd "..filedir.." && cargo run)"
            --     end
            --   end
            --
            -- end
            --
            -- return "(cd "..filedir.." && rustc "..filepath.." && ./"..filename..")"

            local filename = string.match(filepath, "[^/]+$"):sub(1, -4)
            return "(rustc " .. filepath .. " && ./" .. filename .. ")"
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
            return "(cd " .. filedir .. " && npm run dev)"
        end,
    }

    require("nvchad.term").runner {
        pos = "float",
        cmd = commands[filetype](file),
        id = "floatTerm",
        clear_cmd = false
    }
end

return M
