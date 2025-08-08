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

return M
