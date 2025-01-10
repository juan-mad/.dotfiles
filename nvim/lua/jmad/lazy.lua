
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
    checker = {enabled = true},
    -- Fuzzy finder FTW
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        -- or                              , branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            { 'nvim-tree/nvim-web-devicons' }
        }
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
        'numToStr/Comment.nvim', opts = {}
    },
    {
        'ThePrimeagen/vim-be-good'
    },
    -- {  not working for me :(
    --     'SmiteshP/nvim-navic'
    -- },
    {
        'nvim-treesitter/nvim-treesitter-context'
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
        'saadparwaiz1/cmp_luasnip'
    },
    {
        'L3MON4D3/LuaSnip',
        dependencies = {
            {'rafamadriz/friendly-snippets'},
        },
        config = function()
            require("luasnip.loaders.from_lua").load({paths = "~/.snippets" })
        end
    },
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },
    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        -- dependencies = {
        --     {'L3MON4D3/LuaSnip'},
        -- },
        config = function()
            -- Here come the autocompletion setting
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_cmp()

            -- and cmp can be configured further
            local cmp = require('cmp')
            local cmp_format = lsp_zero.cmp_format()
            local cmp_action = lsp_zero.cmp_action()

            require('luasnip.loaders.from_vscode').lazy_load()

            cmp.setup({
                sources = {
                    {name = 'luasnip'},  -- snippets of LuaSnip and friendly-snippets
                    {name = 'nvim_lsp'},  -- comes with lsp-zero
                    {name = 'nvim_lua'},  -- neovim's lua completion
                    -- {name = 'buffer'},  -- autocomplete looking at curr file
                    {name = 'path'},  -- paths of files and folders
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
                    ['<C-l>'] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Insert}),
                    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                    ['<C-g>'] = cmp_action.luasnip_jump_backward(),
                },
                experimental = {
                    ghost_text = true
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered()
		        },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
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
                vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev({severity=vim.diagnostic.severity.WARN}) end)
                vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next({severity=vim.diagnostic.severity.WARN}) end)



                -- if client.server_capabilities.documentSymbolProvider then
                --     require('nvim-navic').attach(client, bufnr)
                -- end
            end)
            -- diagnostic
            vim.diagnostic.config({
                virtual_text = true,
                underline = true
            })
            require('mason-lspconfig').setup({
                ensure_installed = {'pyright'},
                handlers = {
                    lsp_zero.default_setup,
                    -- here come the language servers
                    -- add their name as a function, and configure them
                    lua_ls = function()
                        -- (Optronal) configure lua LS for neovim
                        local lua_opts = lsp_zero.nvim_lua_ls()
                        require('lspconfig').lua_ls.setup(lua_opts)
                    end,

                    pyright = function ()
                        require('lspconfig').pyright.setup({
                        })
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
                            },
                        })
                    end,
                }
            })
        end
    },
    {
        'nvimtools/none-ls.nvim',
        ft = {'python'},
        opts = {
            function ()
                return require "jmad.none_ls"
            end
        }
    },
    {
      "ray-x/go.nvim",
      dependencies = {  -- optional packages
        "ray-x/guihua.lua",
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        require("go").setup()
      end,
      event = {"CmdlineEnter"},
      ft = {"go", 'gomod'},
      build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },
    -- debugger
    {
     "mfussenegger/nvim-dap",
     lazy = true,
     dependencies = {
      "jay-babu/mason-nvim-dap.nvim",
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "anuvyklack/hydra.nvim",
      "nvim-telescope/telescope-dap.nvim",
      "rcarriga/cmp-dap",
     },
     keys = {
      { "<leader>d", desc = "Open Debug menu" },
     },
     cmd = {
      "DapContinue",
      "DapLoadLaunchJSON",
      "DapRestartFrame",
      "DapSetLogLevel",
      "DapShowLog",
      "DapStepInto",
      "DapStepOut",
      "DapStepOver",
      "DapTerminate",
      "DapToggleBreakpoint",
      "DapToggleRepl",
     },
     config = function()
       require("jmad.dap")
       require("mason-nvim-dap").setup({ ensure_installed = { "firefox", "node2" } })
      local ok_telescope, telescope = pcall(require, "telescope")
      if ok_telescope then
       telescope.load_extension("dap")
      end

      local ok_cmp, cmp = pcall(require, "cmp")
      if ok_cmp then
       cmp.setup.filetype({ "dap-repl", "dapui_watches" }, {
        sources = cmp.config.sources({
         { name = "dap" },
        }, {
         { name = "buffer" },
        }),
       })
      end
     end,
    },
    {
        'mfussenegger/nvim-dap-python',
        ft = {'python'},
        dependencies = {
            'mfussenegger/nvim-dap',
            'rcarriga/nvim-dap-ui',
        },
        config = function(_, opts)
            local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
            local dap = require("dap-python")
            dap.setup(path)
            -- Debug Python Run
            vim.keymap.set("n", "<leader>dpr", function()
                dap.test_method()

            end)
        end
    }
})
--     {
--         'rcarriga/nvim-dap-ui',
--         dependencies = {
--             'mfussenegger/nvim-dap'
--         },
--         config = function ()
--             local dap =require('dap')
--             local dapui =require('dapui')
--             dapui.setup()
--             dap.listeners.after.event_initialized["dapui_config"] = function ()
--                 dapui.open()
--             end
--             dap.listeners.after.event_terminated["dapui_config"] = function ()
--                 dapui.close()
--             end
--             dap.listeners.before.event_exited["dapui_config"] = function ()
--                 dapui.close()
--             end
--         end
--     }
-- })
--
