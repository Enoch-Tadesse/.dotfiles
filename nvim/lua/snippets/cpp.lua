local ls = require "luasnip"
local r = ls.restore_node
local d = ls.dynamic_node
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local sn = ls.snippet_node
local rep = require("luasnip.extras").rep

ls.add_snippets("cpp", {
    -- s("prep", {
    --     t({
    --         "#include <bits/stdc++.h>",
    --         "",
    --     }),
    -- }),
    s("fast", {
        t {
            "#include <bits/stdc++.h>",
            "using namespace std;",
            "template <typename T>",
            "T getMax(const std::vector<T> &nums) {",
            "\treturn *max_element(nums.begin(), nums.end());",
            "}",
            "typedef long long ll;",
            "",
            "",
            "",
            "void solve(){",
            "\t",
        },
        i(0),
        t { "", "}" },
        t {
            "",
            "int main(){",
            "",
            "\tios::sync_with_stdio(false);",
            "\tcin.tie(nullptr);",
            "",
            "\t",
        },
        t { "int t = 1;", "\t" },
        i(1),

        t {
            "",
            "\twhile(t--){",
            "\t\tsolve();",
            "\t}",
            "}",
        },
    }),

    s("tcase", {
        t {
            "int t;",
            "cin >> t;",
            "while (t--) {",
            "    ",
        },
        i(1),
        t { "", "}" },
    }),

    s("rint", {
        t "int ",
        i(1, "num"),
        t { ";", "cin >> " },
        rep(1),
        t { ";", "" }, -- Ends the line after the snippet content
        i(0), -- Final node: moves cursor to a new line ready for further editing
    }),

    s("rstr", {
        t "string ",
        i(1, "word"),
        t { ";", "cin >> " },
        rep(1),
        t { ";", "" },
        i(0),
    }),

    s("riarr", {
        t "vector<int> ",
        i(1, "arr"),
        t "(",
        i(2, "n"),
        t ")",
        t { ";", "for (int &x : " },
        rep(1),
        t { "){", "\tcin >> x;", "}" },
        i(0),
    }),

    s("rsarr", {
        t "vector<string> ",
        i(1, "arr"),
        t "(",
        i(2, "n"),
        t ")",
        t { ";", "for (string &s : " },
        rep(1),
        t { "){", "\tcin >> s;", "}" },
        i(0),
    }),

    s("rcstr", {
        t "vector<char> ",
        i(1, "arr"),
        t { ";", "string s;", "cin >> s;", "" },
        -- t({ "" }),
        rep(1),
        t ".assign(s.begin(), s.end());",
        i(0),
    }),

    s("rcsmat", {
        t "vector<vector<char>> ",
        i(1, "mat"),
        t { "(r, vector<char>(c));", "" },
        t { "for (int i = 0; i < r; i++) {", "\tstring s;", "\tcin >> s;", "\t" },
        rep(1),
        t { "[i].assign(s.begin(), s.end());", "}" },
        i(0),
    }),

    s("rsmat", {
        t "vector<vector<string>> ",
        i(1, "mat"),
        t { "(r, vector<string>(c));", "" },
        t { "for (int i = 0; i < r; i++)", "\tfor (int j = 0; j < c; j++) {", "\t\tcin >> " },
        rep(1),
        t { "[i][j];", "\t}" },
        i(0),
    }),

    s("rimat", {
        t "vector<vector<int>> ",
        i(1, "mat"),
        t { "(r, vector<int>(c));", "" },
        t { "for (int i = 0; i < r; i++)", "\tfor (int j = 0; j < c; j++) {", "\t\tcin >> " },
        rep(1),
        t { "[i][j];", "\t}" },
        i(0),
    }),
})
