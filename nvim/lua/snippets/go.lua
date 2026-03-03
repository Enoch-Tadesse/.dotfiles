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
    s("bson", {
        t {
            '`bson:"',
        },
        i(0),
        t { '"`' },
    }),

    s("gorm", {
        t {
            '`gorm:"',
        },
        i(0),
        t { '"`' },
    }),

    s("cuscon", {
        t { "ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)", "" },
        t { "defer cancel()" },
        i(0),
    }),

    s("middleware", {
        t {
            "func middleware(next http.Handler) http.Handler {",
            "\treturn http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {",
            "",
        },
        i(0),
        t {
            "\t\t",
            "\t\tnext.ServeHTTP(w, r)",
            "\t})",
            "}",
        },
    }),
    s("callmiddleware", {
        t {
            'http.Handle("GET /ping", middleware(http.HandlerFunc(function_name)))',
        },
    }),
})
