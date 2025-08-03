
return {
  {
    "Exafunction/codeium.nvim",
    event = "BufEnter",
    build = ":Codeium Auth",
    config = function()
      require("codeium").setup({})
    end,
  },
}
