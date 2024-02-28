
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
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true
    },
    -- Autocompletion
    {
        '-hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            {'L3M0N4D3/LuaSnip'},
        },
        config = function()
            -- Here come the autocompletion settings
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_cmp()

            -- and cmp can be configured further
            -- local cmp = require('cmp')
            -- local cmp_action = lsp_zero.cmp_format()

            -- cmp.setup({
            --     formatting = lsp.cmp_format(),
            --     mapping = cmp.mapping.preset.insert({
            --         ['<C-Space>'] = cmp.mapping.complete(),
            --         ['<C-u>'] = cmp.mapping.scroll_docs(-4),
            --         ['<C-d>'] = cmp.mapping.scroll_docs(4),
            --         ['<C-f>'] = cmp_action.luasnip_jump_forward(),
            --         ['<C-b>'] = cmp_action.luasnip_jump_backward(),
            --     })
            -- )}
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
                lsp_zero.default_keymaps({buffer = bufnr})
            end)

            require('mason-lspconfig').setup({
                ensure_installed = {},
                handlers = {
                    lsp_zero.default_setup,
                    lua_ls = function()
                        -- (Optronal) configure lua LS for neovim
                        local lua_opts = lsp_zero.nvim_lua_ls()
                        require('lspconfig').lua_ls.setup(lua_opts)
                    end,
                }
            })
        end
    }
})

