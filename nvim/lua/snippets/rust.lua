local ls = require "luasnip"
local r = ls.restore_node
local d = ls.dynamic_node
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local sn = ls.snippet_node
local rep = require("luasnip.extras").rep

ls.add_snippets("rust", {
    s("fast", {
        t {
            "use std::io::{self, BufRead};",
            "",
            "fn rl() -> String {",
            "    let mut s = String::new();",
            "    io::stdin().lock().read_line(&mut s).unwrap();",
            "    s.trim().to_string()",
            "}",
            "",
            "fn read<T: std::str::FromStr>() -> T {",
            "    rl().parse::<T>().ok().unwrap()",
            "}",
            "",
            "fn rp<T: std::str::FromStr, U: std::str::FromStr>() -> (T, U) {",
            "    let line = rl();",
            "    let mut iter = line.split_whitespace();",
            "    let a = iter.next().unwrap().parse::<T>().ok().unwrap();",
            "    let b = iter.next().unwrap().parse::<U>().ok().unwrap();",
            "    (a, b)",
            "}",
            "",
            "fn rv<T: std::str::FromStr>() -> Vec<T> {",
            "    rl()",
            "        .split_whitespace()",
            "        .map(|x| x.parse::<T>().ok().unwrap())",
            "        .collect()",
            "}",
            "",
            "fn show<T: std::fmt::Display>(data: &Vec<T>) {",
            '\tdata.iter().for_each(|c| print!("{} ", c));',
            "\tprintln!();",
            "}",
            "",
            "fn solve() {",
            "\t",
        },

        i(0),
        t {
            "",
            "}",
            "",
            "",
            "",
            "fn main() {",
            "\tlet t : i32 = ",
        },
        i(1, "read()"),
        t {
			";",
            "",
            "\tfor _ in 0..t {",
            "\t\tsolve();",
            "\t}",
            "}",
        },
    }),
})
