-- Import cmp and luasnip
local cmp = require "cmp"
local luasnip = require "luasnip"
cmp.setup {
    -- Snippet configuration
    --
    experimental = {
        ghost_text = true, -- inline preview
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body) -- Expand snippet
        end,
    },
    preselect = cmp.PreselectMode.Item, -- Always preselect the first item
    completion = {
        completeopt = "menu,menuone,noinsert", -- Ensures the first item is highlighted but not auto-inserted
    },

    window = {
        -- completion = cmp.config.window.bordered(), -- Adds a border to completion menu
        documentation = cmp.config.window.bordered(), -- Adds a border to documentation popup
    },

    -- Key mappings
    mapping = cmp.mapping.preset.insert {
        ["<Tab>"] = cmp.mapping.select_next_item(), -- Use Tab to confirm completion
        ["<S-Tab>"] = cmp.mapping.select_prev_item(), -- Use Shift+Tab to go to the previous item
        ["<C-b>"] = cmp.mapping.scroll_docs(-4), -- Scroll up in documentation
        ["<C-f>"] = cmp.mapping.scroll_docs(4), -- Scroll down in documentation
        ["<C-j>"] = cmp.mapping.complete(), -- Trigger completions
        ["<C-e>"] = cmp.mapping.abort(), -- Close completion
        ["<CR>"] = cmp.mapping.confirm { select = true }, -- Confirm completion
    },
    -- sorting = {
    --     priority_weight = 2, -- Give more weight to priority values
    -- },

    -- Completion sources
    sources = cmp.config.sources({
        { name = "luasnip", priority = 200 }, -- LuaSnip source for snippets, includes the custom ones

        { name = "nvim_lsp", priority = 150 }, -- LSP source for completions
    }, {
        { name = "buffer", priority = 100 }, -- Buffer source for words already in the buffer
        { name = "path" },
    }),

    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
            })[entry.source.name]
            return vim_item
        end,
    },

    -- Filetype-specific configurations (for gitcommit)
    cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
            { name = "cmp_git" }, -- Git-related completions
        }, {
            { name = "buffer" },
        }),
    }),
}
