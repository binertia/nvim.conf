return {
    "debugloop/telescope-undo.nvim",
    dependencies = { -- note how they're inverted to above example
        {
            "nvim-telescope/telescope.nvim",
            dependencies = { "nvim-lua/plenary.nvim" },
        },
    },
    opts = {
        -- don't use `defaults = { }` here, do this in the main telescope spec
        extensions = {
            undo = {
                -- telescope-undo.nvim config, see below
                side_by_side = true,
                layout_strategy = "bottom_pane",
                layout_config = {
                    bottom_pane = {
                        height = 37,
                        preview_cutoff = 120,
                        prompt_position = "top",
                    },
                },
            },
            -- no other extensions here, they can have their own spec too
        },
    },
    config = function(_, opts)
        -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
        -- configs for us. We won't use data, as everything is in it's own namespace (telescope
        -- defaults, as well as each extension).
        require("telescope").setup(opts)
        require("telescope").load_extension("undo")
    end,
}
--
  -- 			bottom_pane = {
  --   height = 25,
  --   preview_cutoff = 120,
  --   prompt_position = "top"
  -- },
  -- center = {
  --   height = 25,
  --   preview_cutoff = 40,
  --   prompt_position = "top",
  --   width = 0.5
  -- },
  -- cursor = {
  --   height = 25,
  --   preview_cutoff = 40,
  --   width = 0.8
  -- },
  -- height = 25,
  -- horizontal = {
  --   height = 25,
  --   preview_cutoff = 120,
  --   prompt_position = "bottom",
  --   width = 0.8
  -- },
  -- preview_height = 1.2,
  -- preview_width = 1.2,
  -- vertical = {
  --   height = 25,
  --   preview_cutoff = 40,
  --   prompt_position = "bottom",
  --   width = 0.8
  -- }
