return {
  "L3MON4D3/LuaSnip",
  dependencies = {},
  opts = function(_, opts)
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local f = ls.function_node

    local function filename_base()
      return vim.fn.expand("%:t:r")
    end

    -- Add your snippet for multiple filetypes
    local cssImportSnippet = s("csm", {
      t("import styles from './"),
      f(filename_base, {}),
      t(".module.css';"),
    })

    -- Register for multiple filetypes
    ls.add_snippets("javascriptreact", { cssImportSnippet })
    ls.add_snippets("typescriptreact", { cssImportSnippet })
    ls.add_snippets("javascript", { cssImportSnippet })
    ls.add_snippets("typescript", { cssImportSnippet })
  end,
}

