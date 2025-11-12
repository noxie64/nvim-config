local lazy = {

    -- color-themes
    "rebelot/kanagawa.nvim",
    "folke/tokyonight.nvim",
    "EdenEast/nightfox.nvim",
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    "nvim-tree/nvim-tree.lua",
    "nvim-treesitter/nvim-treesitter",
    "savq/melange-nvim",
    "ThePrimeagen/harpoon",
    "nvim-lua/plenary.nvim",
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "MaximilianLloyd/ascii.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
    },

    -- LSP
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "nvimtools/none-ls.nvim",
    "neovim/nvim-lspconfig",
    "jay-babu/mason-null-ls.nvim",

    -- Auto-complete
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",

    -- Snippets
    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "saadparwaiz1/cmp_luasnip",
        },
    },

    -- Autopairing
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },
    "windwp/nvim-ts-autotag",

    -- Other
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
    "ellisonleao/gruvbox.nvim",
    "folke/todo-comments.nvim",
    {
        "lervag/vimtex",
        lazy = false,
        init = function()
            vim.g.vimtex_view_method = "zathura"
            vim.g.vimtex_compiler_method = "latexmk"
            vim.g.vimtex_compiler_latexmk = {
                out_dir = ".latex_build"
            }
                       end,
    },
}

return lazy
