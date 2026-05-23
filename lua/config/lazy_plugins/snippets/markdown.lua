local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("markdown", {
    s("meta", fmt([[
---
title: "{}"
author: [ {} ]
date: "{}"
...
{}]], {
        i(1, "Title"),
        i(2, "Author"),
        f(function() return os.date("%Y-%m-%d") end, {}),
        i(0),
    })),
})
