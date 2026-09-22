local plugin_spec = {
    ----------------------
    --   color-themes   --
    ----------------------
    "rebelot/kanagawa.nvim",
    "folke/tokyonight.nvim",
    "EdenEast/nightfox.nvim",
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    "savq/melange-nvim",
    "yorumicolors/yorumi.nvim",
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    "mistweaverco/retro-theme.nvim",
    "tomasr/molokai",
    "ellisonleao/gruvbox.nvim",
    {
        "navarasu/onedark.nvim",
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require("onedark").setup({
                style = "cool",
            })
            require("onedark").load()
        end,
    },

    -------------------------
    ---   functionality   ---
    -------------------------
    "nvim-tree/nvim-tree.lua",
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
    },
    "nvim-lua/plenary.nvim",
    -- fuzzy-search
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    -- file-browser for telescope
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    },

    --    LSP   --
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "nvimtools/none-ls.nvim",
    "neovim/nvim-lspconfig",
    "jay-babu/mason-null-ls.nvim",

    --    Auto-complete   --
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",

    --   Snippets   --
    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "saadparwaiz1/cmp_luasnip",
        },
    },

    --   Autopairing   --
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },
    "windwp/nvim-ts-autotag",

    ---------------
    --   Other   --
    ---------------

    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
    -- show todos
    "folke/todo-comments.nvim",
    -- latex-support
    {
        "lervag/vimtex",
        lazy = false,
        init = function()
            vim.g.vimtex_view_method = "zathura"
            vim.g.vimtex_compiler_method = "latexmk"
            vim.g.vimtex_compiler_latexmk = {
                build_dir = ".latex_build",
                aux_dir = ".latex_build",
                options = {
                    "-shell-escape",
                },
            }
        end,
    },
    -- startup-screen
    "goolord/alpha-nvim",
    -- image-viewer for nvim
    {
        "3rd/image.nvim",
        opts = {
            backend = "kitty",
        },
    },
    -- fortunes for startup-screen
    "rubiin/fortune.nvim",
    -- remove trailing whitespaces
    { "jdhao/whitespace.nvim", event = "VeryLazy" },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
        },
    },
    "Weissle/persistent-breakpoints.nvim",
    "mfussenegger/nvim-dap-python",
}

return plugin_spec
