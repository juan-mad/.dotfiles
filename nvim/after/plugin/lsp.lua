local lsp = require('lsp-zero')

local repterm = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")

lsp.preset("recommended")

lsp.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp.default_keymaps({buffer = bufnr})
end)

local cmp = require("cmp")
local cmp_action = lsp.cmp_action()

cmp.setup({
    preselect = true,
    completion = {
        completeopt = 'menu,menuone,noinsert'
    } 
})

local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
    -- Select previous option of autocomplete list
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),

    -- Select next option of autocomplete list
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),

    ["<CR>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.confirm({select=true})
        else
            fallback()
        end
    end, {"i", "s"}),
    ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
            -- they way you will only jump inside the snippet region
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        elseif has_words_before() then
            cmp.complete()
        else
            fallback()
        end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end, { "i", "s" }),

})
-- on_attach happens on every buffer with associated LSP. Remaps only live for this buffer.
-- It will use the LSP unless it does not exist, which then will use vim's

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})


lsp.on_attach(function (client, bufnr)
    local opts = {buffer = bufnr, remap = false}

    -- Go to definition
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("n", "<leader>nd", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "<leader>pd", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
end)

require('lspconfig').pylsp.setup({
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    ignore = {'W391'},
                    maxLineLength = 100
                }
            }
        }
    }
})

lsp.setup()
