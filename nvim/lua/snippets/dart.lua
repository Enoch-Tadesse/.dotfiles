local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require "luasnip.util.events"
local ai = require "luasnip.nodes.absolute_indexer"
local extras = require "luasnip.extras"
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require "luasnip.extras.expand_conditions"
local postfix = require("luasnip.extras.postfix").postfix
local types = require "luasnip.util.types"
local parse = require("luasnip.util.parser").parse_snippet

ls.add_snippets("go", {
    s("importm", {
        t {
            "import 'package:flutter/material.dart';'",
        },
        t { "" },
    }),
})

return {
    s(
        { trig = "stless", name = "Stateless Widget", dscr = "Creates a Stateless Widget" },
        fmt(
            [[
      class {} extends StatelessWidget {{
        const {}({{super.key}});

        @override
        Widget build(BuildContext context) {{
          return {};
        }}
      }}
    ]],
            {
                i(1, "MyWidget"),
                rep(1),
                i(2, "Container()"),
            }
        )
    ),
    s { trig = "importm", fmt [[ 
	import 'package:flutter/material.dart';
  ]] },

    s(
        { trig = "stful", name = "Stateful Widget", dscr = "Creates a Stateful Widget" },
        fmt(
            [[
      class {} extends StatefulWidget {{
        const {}({{super.key}});

        @override
        State<{}> createState() => _{}State();
      }}

      class _{}State extends State<{}> {{
        @override
        Widget build(BuildContext context) {{
          return {};
        }}
      }}
    ]],
            {
                i(1, "MyWidget"),
                rep(1),
                rep(1),
                rep(1),
                rep(1),
                rep(1),
                i(2, "Container()"),
            }
        )
    ),

    s(
        { trig = "scaf", name = "Scaffold Widget", dscr = "Creates a Scaffold Widget" },
        fmt(
            [[
      Scaffold(
        appBar: AppBar(
          title: const Text('{}'),
        ),
        body: {},
      )
    ]],
            {
                i(1, "Title"),
                i(2, "const Center(child: Text('Hello'))"),
            }
        )
    ),

    s(
        { trig = "cont", name = "Container Widget", dscr = "Creates a Container Widget" },
        fmt(
            [[
      Container(
        {}: {},
        child: {},
      )
    ]],
            {
                i(1, "width"),
                i(2, "100.0"),
                i(3, "const Text('')"),
            }
        )
    ),

    s(
        { trig = "txt", name = "Text Widget", dscr = "Creates a Text Widget" },
        fmt(
            [[
      Text(
        '{}',
        style: {},
      )
    ]],
            {
                i(1, "text"),
                i(2, "const TextStyle()"),
            }
        )
    ),

    s(
        { trig = "col", name = "Column Widget", dscr = "Creates a Column Widget" },
        fmt(
            [[
      Column(
        children: [
          {},
        ],
      )
    ]],
            {
                i(1, "const Text('')"),
            }
        )
    ),

    s(
        { trig = "row", name = "Row Widget", dscr = "Creates a Row Widget" },
        fmt(
            [[
      Row(
        children: [
          {},
        ],
      )
    ]],
            {
                i(1, "const Text('')"),
            }
        )
    ),

    s(
        { trig = "lvb", name = "ListView Builder", dscr = "Creates a ListView.builder" },
        fmt(
            [[
      ListView.builder(
        itemCount: {},
        itemBuilder: (context, index) {{
          return {};
        }},
      )
    ]],
            {
                i(1, "items.length"),
                i(2, "ListTile(title: Text(''))"),
            }
        )
    ),

    s(
        { trig = "futb", name = "Future Builder", dscr = "Creates a FutureBuilder" },
        fmt(
            [[
      FutureBuilder<{}>(
        future: {},
        builder: (context, snapshot) {{
          if (snapshot.hasData) {{
            return Text(snapshot.data!);
          }} else if (snapshot.hasError) {{
            return Text('${{snapshot.error}}');
          }}
          return const CircularProgressIndicator();
        }},
      )
    ]],
            {
                i(1, "String"),
                i(2, "_future"),
            }
        )
    ),

    s(
        { trig = "strb", name = "Stream Builder", dscr = "Creates a StreamBuilder" },
        fmt(
            [[
      StreamBuilder<{}>(
        stream: {},
        builder: (context, snapshot) {{
          if (snapshot.hasData) {{
            return Text(snapshot.data!);
          }} else if (snapshot.hasError) {{
            return Text('${{snapshot.error}}');
          }}
          return const CircularProgressIndicator();
        }},
      )
    ]],
            {
                i(1, "String"),
                i(2, "_stream"),
            }
        )
    ),

    s(
        { trig = "elbtn", name = "Elevated Button", dscr = "Creates an ElevatedButton" },
        fmt(
            [[
      ElevatedButton(
        onPressed: {},
        child: const Text('{}'),
      )
    ]],
            {
                i(1, "(){}"),
                i(2, "Button"),
            }
        )
    ),

    s(
        { trig = "txtbtn", name = "Text Button", dscr = "Creates a TextButton" },
        fmt(
            [[
      TextButton(
        onPressed: {},
        child: const Text('{}'),
      )
    ]],
            {
                i(1, "(){}"),
                i(2, "Button"),
            }
        )
    ),

    s(
        { trig = "icbtn", name = "Icon Button", dscr = "Creates an IconButton" },
        fmt(
            [[
      IconButton(
        onPressed: {},
        icon: const Icon({}),
      )
    ]],
            {
                i(1, "(){}"),
                i(2, "Icons.add"),
            }
        )
    ),

    s(
        { trig = "sbh", name = "SizedBox Height", dscr = "SizedBox with height" },
        fmt("SizedBox(height: {})", {
            i(1, "10.0"),
        })
    ),

    s(
        { trig = "sbw", name = "SizedBox Width", dscr = "SizedBox with width" },
        fmt("SizedBox(width: {})", {
            i(1, "10.0"),
        })
    ),

    s(
        { trig = "init", name = "Init State", dscr = "initState method" },
        fmt(
            [[
      @override
      void initState() {{
        super.initState();
        {}
      }}
    ]],
            {
                i(1),
            }
        )
    ),

    s(
        { trig = "disp", name = "Dispose", dscr = "dispose method" },
        fmt(
            [[
      @override
      void dispose() {{
        {}
        super.dispose();
      }}
    ]],
            {
                i(1),
            }
        )
    ),

    s(
        { trig = "build", name = "Build Method", dscr = "build method" },
        fmt(
            [[
      @override
      Widget build(BuildContext context) {{
        return {};
      }}
    ]],
            {
                i(1, "Container()"),
            }
        )
    ),
}
