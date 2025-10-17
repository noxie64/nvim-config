local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

require("luasnip").add_snippets("jsonc", {
    s("tsconfig", {
        t({
            "{",
            '    "compilerOptions": {',
            '        "target": "esnext",',
            '        "module": "commonjs",',
            '        "strict": true,',
            '        "esModuleInterop": true,',
            '        "skipLibCheck": true,',
            '        "forceConsistentCasingInFileNames": true',
            "    },",
            '    "include": [',
            '        "src"',
            "    ],",
            '    "exclude": [',
            '        "node_modules",',
            '        "dist"',
            "    ]",
            "}",
        }),
    }),
})
