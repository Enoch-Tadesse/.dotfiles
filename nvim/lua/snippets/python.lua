local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep

vim.api.nvim_set_keymap("i", "<A-.>", [[<cmd>lua require'luasnip'.jump(1)<CR>]], { noremap = true })
vim.api.nvim_set_keymap("s", "<A-.>", [[<cmd>lua require'luasnip'.jump(1)<CR>]], { noremap = true })

vim.api.nvim_set_keymap("i", "<A-,>", [[<cmd>lua require'luasnip'.jump(-1)<CR>]], { noremap = true })
vim.api.nvim_set_keymap("s", "<A-,>", [[<cmd>lua require'luasnip'.jump(-1)<CR>]], { noremap = true })

ls.add_snippets("python", {

    s("recur", {
        t {
            "import sys",
            "import threading",
            "from collections import Counter, defaultdict",
            "from bisect import bisect_left, bisect_right",
            "from copy import deepcopy",
            "import math",
            "",
            "# input = input",
            "input = sys.stdin.readline",
            "",
            "",
            "def solve():",
            "\t",
        },
        i(0),
        t {
            "",
            "",
            "",
            "def main():",
            "\tt = ",
        },
        i(1, "rint"),
        t {
            "",
            "\tfor _ in range(t):",
            "\t\tsolve()",
            "",
            "",
            "if __name__ == '__main__':",
            "\tsys.setrecursionlimit(1 << 30)",
            "\tthreading.stack_size(1 << 27)",
            "",
            "\tmain_thread = threading.Thread(target=main)",
            "\tmain_thread.start()",
            "\tmain_thread.join()",
        },
    }),

    s("smpre", {
        i(1, "fillhere"),
        t {
            " = deepcopy(",
        },
        i(2, "nums"),
        t {
            ")",
            "",
            "for nr in range(r):",
            "\tfor nc in range(1, c):",
            "\t\t",
        },
        rep(1),
        t {
            "[nr][nc] += ",
        },
        rep(1),
        t {
            "[nr][nc - 1]",
            "",
            "",
        },
    }),

    s("umpre", {
        i(1, "fillhere"),
        t " = deepcopy(",
        i(2, "nums"),
        t { ")", "" },
        t "for nc in range(c):",
        t { "", "\tfor nr in range(1, r):" },
        t { "\t\t" },
        rep(1),
        t "[nr][nc] += ",
        rep(1),
        t { "[nr - 1][nc]", "", "" },
    }),

    s("fmpre", {
        i(1, "pmat"),
        t " = deepcopy(",
        i(2, "nums"),
        t { ")", "" },
        t "for nr in range(r):",
        t { "", "\tfor nc in range(1, c):", "\t\t" },
        rep(1),
        t " [nr][nc] += ",
        rep(1),
        t "[nr][nc-1]",
        t { "", "for nc in range(c):", "\tfor nr in range(1, r):", "\t\t" },
        rep(1),
        t "[nr][nc] += ",
        rep(1),
        t { "[nr - 1][nc]", "", "" },
        t "",
        i(0),
    }),

    s("gridsum", {
        t {
            "(",
        },
        i(1, "pmat"),
        t { "    [row2][col2]" },
        t { "    - (" },
        rep(1),
        t { "[row1 - 1][col2] if row1 > 0 else 0)" },

        t { "    - (" },
        rep(1),
        t { "[row2][col1 - 1] if col1 > 0 else 0)" },

        t { "    + (" },
        rep(1),
        t { "[row1 - 1][col1 - 1] if row1 > 0 and col1 > 0 else 0)" },
        t { ")" },
    }),

    s("fast", {
        t {
            "import sys",
            "from collections import Counter, defaultdict",
            "from bisect import bisect_left, bisect_right",
            "from copy import deepcopy",
            "import math",
            "",
            "# input = input",
            "input = sys.stdin.readline",
            "",
            "",
            "def solve():",
            "\t",
        },
        i(0),
        t {
            "",
            "",
            "",
            "def main():",
            "\tt = ",
        },
        i(1, "rint"),
        t {
            "",
            "\tfor _ in range(t):",
            "\t\tsolve()",
            "",
            "",
            "if __name__ == '__main__':",
            "\tmain()",
        },
    }),

    s("rimat", {
        t {
            "[list(map(int, input().split())) for _ in range(r)]",
            "",
        },
    }),

    s("tcase", {
        t {
            "t = int(input())",
            "for _ in range(t):",
            "\t",
        },
        i(0),
    }),

    s("rint", {
        t {
            "int(input())",
            "",
        },
    }),

    s("rstr", {
        t {
            "input().strip()",
            "",
        },
    }),

    s("riarr", {
        t {
            "list(map(int, input().split()))",
            "",
        },
    }),

    s("rsarr", {
        t {
            "input().split()",
            "",
        },
    }),

    s("rcstr", {
        t {
            "list(x for x in input().strip())",
            "",
        },
    }),

    s("rcsmat", {
        t {
            "[[x for x in input().strip()] for _ in range(r)]",
            "",
        },
    }),

    s("rsmat", {
        t {
            "[list(input().split()) for _ in range(r)]",
            "",
        },
    }),

    s("rimat", {
        t {
            "[list(map(int,input.split())) for _ in range(r)]",
            "",
        },
    }),
})
