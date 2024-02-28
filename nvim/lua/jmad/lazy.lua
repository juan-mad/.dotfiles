
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
    -- {
    --     'VonHeikemen/lsp-zero.nvim',
    --     branch = 'v2.x',
    --     dependencies = {
    --           -- LSP Support
    --         {'neovim/nvim-lspconfig'},             -- Required
    --         {'williamboman/mason.nvim'},           -- Optional
    --         {'williamboman/mason-lspconfig.nvim'}, -- Optional

    --         -- Autocompletion
    --         {'hrsh7th/nvim-cmp'},     -- Required
    --         {'hrsh7th/cmp-nvim-lsp'}, -- Required
    --         {'L3MON4D3/LuaSnip'},     -- Required
    --     }
    -- },
    -- Unintrusive UI for neovim notifications and LSP progress messages
    {
        'j-hui/fidget.nvim'
    },
    -- Snippets
    {
        'L3MON4D3/LuaSnip'
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
    }
})

