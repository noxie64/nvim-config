local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node

require("luasnip").add_snippets("tex", {
    s("geo", {
        t({
            "\\usepackage[margin=2cm]{geometry}",
        }),
    }),
    s("art", {
        t({
            "\\documentclass{article}",
        }),
    }),

})
