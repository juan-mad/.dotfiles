
-- Install the lazy.nvim plugin manager

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Configure plugins
require("lazy").setup({
    checker = {enabled = false},
    -- Fuzzy finder FTW
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        -- or                              , branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    -- tokyonight color themes
    {
        'folke/tokyonight.nvim'
    },
    -- Highlight, edit, and navigate code
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    {
        'ThePrimeagen/harpoon'
    },
    {
        'mbbill/undotree'
    },
    -- Git related plugins
    {
        'tpope/vim-fugitive'
    },
    {
        'tpope/vim-rhubarb'
    },
    {
        'terrortylor/nvim-comment'
    },
    -- Unintrusive UI for neovim notifications and LSP progress messages
    {
        'j-hui/fidget.nvim'
    },
    {
        'nvim-lualine/lualine.nvim'
    },
    {
        -- Indentation guides. See :help ibl
        'lukas-reineke/indent-blankline.nvim',
    },
    {
        'numToStr/telescope.nvim', opts = {}
    },
    {
        'ThePrimeagen/vim-be-good'
    },
    {
        'folke/zen-mode.nvim'
    },
    {
        'folke/which-key.nvim',
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 3000
        end,
        opts = {
            -- config in here
        }

    },
    -- LSP zero
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        lazy = true,
        config = false,
        init = function()
            -- Disable auto setip
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },
    -- Autocomplete with looking at current file
    {
        'hrsh7th/cmp-buffer'
    },
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true
    },
    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            {'L3MON4D3/LuaSnip'},
        },
        config = function()
            -- Here come the autocompletion setting
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_cmp()

            -- and cmp can be configured further
            local cmp = require('cmp')
            local cmp_format = lsp_zero.cmp_format()
            local cmp_action = lsp_zero.cmp_action()

            cmp.setup({
                sources = {
                    {name = 'nvim_lsp'},  -- comes with lsp-zero
                    {name = 'nvim_lua'},  -- neovim's lua completion
                    {name = 'buffer'}  -- autocomplete looking at curr file
                },
                formatting = cmp_format,
                -- mapping = cmp.mapping.preset.insert({})
                mapping = {
                    ['<C-y>'] = cmp.mapping.confirm({select=true}),
                    ['<CR>'] = cmp.mapping(function(fallback)
			            fallback()
                    end),
                    ['<C-x>'] = cmp.mapping.abort(),
                    ['<C-j>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                        else
                            cmp.complete()
                            cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select})
                        end
                    end),
                    -- ['<C-j>'] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}),
                    -- ['<C-k>'] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}),
                    ['<C-n>'] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Insert}),
                    ['<C-m>'] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Insert}),
                    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                    ['<C-g>'] = cmp_action.luasnip_jump_backward(),
                },
                experimental = {
                    ghost_text = true
                },
                window = {

                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered()
		        }
            })

        end
    },
    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = {'LspInfo', 'LspInstall', 'LspStart'},
        event = {'BufReadPre', 'BufNewFile'},
        dependencies = {
            {'hrsh7th/cmp-nvim-lsp'},
            {'williamboman/mason-lspconfig.nvim'},
        },
        config = function()
            -- LSP shenaningans in here
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()

            lsp_zero.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn available actions
                -- lsp_zero.default_keymaps({buffer = bufnr})
                
                -- My keybindings
                -- Hover info of symbol under cursor
                vim.keymap.set({"n"}, "K", vim.lsp.buf.hover)
                -- goto definition
                vim.keymap.set({"n"}, "gd", vim.lsp.buf.definition)
                -- list references of symbol under cursor
                vim.keymap.set({"n"}, "gr", vim.lsp.buf.references)
                -- goto type definition
                vim.keymap.set({"n"}, "gt", vim.lsp.buf.type_definition)
                -- signature
                vim.keymap.set({"n"}, "gt", vim.lsp.buf.signature_help)
                -- show diagnostics in page
                vim.keymap.set({"n"}, "gl", vim.diagnostic.open_float)
            end)
            -- diagnostic
            vim.diagnostic.config({
                -- show virtual_text for WARN or ERROR only
                virtual_text = {false, severity = vim.diagnostic.severity.WARN},
                -- Show underline for INFO, WARN or ERROR only
                underline = {false, severity = vim.diagnostic.severity.INFO}
            })

            require('mason-lspconfig').setup({
                ensure_installed = {},
                handlers = {
                    lsp_zero.default_setup,
                    -- here come the language servers
                    -- add their name as a function, and configure them
                    
                    lua_ls = function()
                        -- (Optronal) configure lua LS for neovim
                        local lua_opts = lsp_zero.nvim_lua_ls()
                        require('lspconfig').lua_ls.setup(lua_opts)
                    end,

                    pylsp = function()
                        require('lspconfig').pylsp.setup({
                            settings = {
                                pylsp = {
                                    plugins = {
                                        pycodestyle = {
                                            maxLineLength = 120
                                        }
                                    }
                                }
                            }
                        })
                    end,
                }
            })
        end
    }
})

