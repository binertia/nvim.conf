return {
    {
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                -- Conform will run multiple formatters sequentially
                javascript = { { "prettierd", "prettier" } },
                -- c = { "clangd_format" },
            },
        }),
    },
}
