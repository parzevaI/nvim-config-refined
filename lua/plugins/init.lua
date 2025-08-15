return {
    -- PACKAGE MANAGER -------------------------
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "pyright",
                "rust-analyzer",
                "typescript-language-server",
                "eslint-lsp",
                "styled-components-language-server",
                "lua-language-server",
                "stylua",
                "html-lsp",
                "css-lsp",
                "prettier",
            },
        },
    },


    -- TEXT EDITING ----------------------------
    -- snippets
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        config = function()
            require('configs.snippets')
        end,
    },

    -- autocompletion
    {
        import = "nvchad.blink.lazyspec"
    },
    {
        "saghen/blink.cmp",
        opts = function(_, opts)
            opts.keymap = opts.keymap or {}
            -- disable default preset so Tab/Shift-Tab aren't mapped by blink
            opts.keymap.preset = 'none'
            -- use Tab / Shift-Tab for snippet field navigation; otherwise fallback
            opts.keymap["<Tab>"] = { "snippet_forward", "fallback" }
            opts.keymap["<S-Tab>"] = { "snippet_backward", "fallback" }
            -- keep your navigation on Ctrl-j/k for completion list
            opts.keymap["<C-j>"] = { "select_next", "fallback" }
            opts.keymap["<C-k>"] = { "select_prev", "fallback" }
            -- accept the current suggestion with Ctrl-l
            opts.keymap["<C-l>"] = { "accept", "fallback" }
        end,
    },

    -- highlight efficient f/F, t/T jump letters
    {
        "jinh0/eyeliner.nvim",
        event = "BufEnter",
    },

    -- format on save
    {
        "stevearc/conform.nvim",
        event = 'BufWritePre', -- uncomment for format on save
        opts = require "configs.conform",
    },

    -- toggle collapsed formatting ("E" mapping)
    {
        'Wansmer/treesj',
        -- keys = { 'E' },
        event = "VeryLazy",
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        opts = { -- switch for config below if this doesn't work
            use_default_keymaps = false,
        },
        -- config = function()
        --     require('treesj').setup({
        --         use_default_keymaps = false,
        --     })
        -- end,
    },

    -- improves vim marks ergonomics
    {
        "chentoast/marks.nvim",
        event = "VeryLazy",
        opts = {},
    },

    -- search text quickly
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            modes = {
                search = {
                    enabled = true
                }
            }
        },
        keys = {
            -- {
            --     "s",
            --     mode = { "n", "x", "o" },
            --     function() require("flash").jump() end,
            --     desc = "Flash",
            -- },
            {
                "S",
                mode = { "n", "o", "x" },
                function() require("flash").treesitter() end,
                desc = "Flash Treesitter",
            },
            {
                "r",
                mode = "o",
                function() require("flash").remote() end,
                desc = "Remote Flash",
            },
            {
                "R",
                mode = { "o", "x" },
                function() require("flash").treesitter_search() end,
                desc = "Treesitter Search",
            },
            {
                "<c-s>",
                mode = { "c" },
                function() require("flash").toggle() end,
                desc = "Toggle Flash Search",
            },
        },
    },

    -- new code structure types (eg. in function, or in css declaration)
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = "BufEnter",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },

    -- auto close and rename tags in markup
    {
        "windwp/nvim-ts-autotag",
        ft = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "html"
        },
        config = function()
            require("nvim-ts-autotag").setup()
        end
    },

    -- syntax hightlights nested delimeters (brackets or then end's) in different colors
    {
        "HiPhish/rainbow-delimiters.nvim",
        event = "BufEnter",
        config = function()
            local rainbow_delimiters = require 'rainbow-delimiters'
            vim.g.rainbow_delimiters = {
                strategy = {
                    [''] = rainbow_delimiters.strategy['global'],
                    vim = rainbow_delimiters.strategy['local'],
                },
                query = {
                    [''] = 'rainbow-delimiters',
                    lua = 'rainbow-blocks',
                    javascript = 'rainbow-delimiters-react',
                    typescript = 'rainbow-delimiters-react',
                    tsx = 'rainbow-delimiters-react',
                    jsx = 'rainbow-delimiters-react',
                },
                highlight = {
                    'RainbowDelimiterRed',
                    'RainbowDelimiterYellow',
                    'RainbowDelimiterBlue',
                    'RainbowDelimiterOrange',
                    'RainbowDelimiterGreen',
                    'RainbowDelimiterViolet',
                    'RainbowDelimiterCyan',
                },
            }
        end
    },


    -- FILES -----------------------------------
    -- repaces telescope and the file explorer (amongst other things)
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            bigfile = { enabled = false },
            dashboard = { enabled = false },
            explorer = { enabled = true },
            indent = { enabled = false },
            input = { enabled = false },
            picker = { enabled = true },
            notifier = { enabled = false },
            quickfile = { enabled = false },
            scope = { enabled = false },
            scroll = { enabled = false },
            statuscolumn = { enabled = false },
            words = { enabled = false },
        },
    },


    -- NVIM CODE COMPREHENSION -----------------
    -- programming language
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "configs.lspconfig"
        end,
    },

    -- code structure
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "vim",
                "lua",
                "vimdoc",
                "html",
                "css",
                "python",
                "rust",
                "javascript",
                "typescript",
                "tsx",
                "styled",
                --                "jsx"
            },
            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<c-space>',
                    node_incremental = '<c-space>',
                    scope_incremental = '<c-s>',
                    node_decremental = '<c-backspace>',
                }
            },

            textobjects = { -- for use with treesitter text-objects plugin
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ['aa'] = '@parameter.outer',
                        ['ia'] = '@parameter.inner',
                        ['af'] = '@function.outer',
                        ['if'] = '@function.inner',
                        ['ao'] = '@class.outer',
                        ['io'] = '@class.inner',
                        ['ii'] = '@conditional.inner',
                        ['ai'] = '@conditional.outer',
                        ['il'] = '@loop.inner',
                        ['al'] = '@loop.outer',
                        ['ic'] = '@comment.inner',
                        ['ac'] = '@comment.outer',
                        ['iv'] = '@assignment.rhs',
                        ['av'] = '@assignment.outer',
                        ['ir'] = '@return.inner',
                        ['ar'] = '@return.inner',
                        ['in'] = '@number.inner',
                        ['ah'] = '@call.outer',
                        ['ih'] = '@call.inner',
                    }
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        [']f'] = '@function.outer',
                        [']]'] = '@class.outer',
                    },
                    goto_next_end = {
                        [']F'] = '@function.outer',
                        [']['] = '@class.outer',
                    },
                    goto_previous_start = {
                        ['[f'] = '@function.outer',
                        ['[['] = '@class.outer',
                    },
                    goto_previous_end = {
                        ['[F'] = '@function.outer',
                        ['[]'] = '@class.outer',
                    },
                    goto_next = {
                        [']i'] = "@conditional.inner",
                    },
                    goto_previous = {
                        ['[i'] = "@conditional.inner",
                    }
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ['<leader>h'] = '@parameter.inner',
                    },
                    swap_previous = {
                        ['<leader>H'] = '@parameter.inner',
                    }
                }
            }
        }
    }


}
