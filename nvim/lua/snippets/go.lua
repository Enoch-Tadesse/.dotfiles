local ls = require "luasnip"
local r = ls.restore_node
local d = ls.dynamic_node
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local sn = ls.snippet_node
local rep = require("luasnip.extras").rep

ls.add_snippets("go", {
    s("gorm", {
        t {
            '`gorm:"',
        },
        i(0),
        t { '"`' },
    }),
})
