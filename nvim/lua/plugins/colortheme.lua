return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Set your preferred style: "storm", "night", "moon", "day"
      vim.g.tokyonight_style = "night"

      -- Initial transparency toggle state
      local bg_transparent = false

      -- Load the theme with config
      require("tokyonight").setup({
        style = "night",
        transparent = bg_transparent,
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
      })

      vim.cmd("colorscheme tokyonight")

      -- Toggle background transparency
      local function toggle_transparency()
        bg_transparent = not bg_transparent
        require("tokyonight").setup({
          style = "night",
          transparent = bg_transparent,
          styles = {
            sidebars = "transparent",
            floats = "transparent",
          },
        })
        vim.cmd("colorscheme tokyonight")
      end

      vim.keymap.set("n", "<leader>bg", toggle_transparency, { desc = "Toggle background transparency" })
    end,
  },
}

