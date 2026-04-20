require("fortune").setup({
    max_width = math.floor(vim.o.columns * .5),
    min_width = math.floor(vim.o.columns * .3),
    display_format = "short",
    content_type = "quotes",
    language = "en",
})
