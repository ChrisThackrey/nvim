return {
	settings = {
      Lua = {
        diagnostics = {
          globals = {
            -- vim
            "vim",

            -- Busted
            "describe",
            "it",
            "before_each",
            "after_each",
            "teardown",
            "pending",
            "clear",

            -- Colorbuddy
            "Color",
            "c",
            "Group",
            "g",
            "s",

            -- Custom
            "RELOAD",
          },
        },

        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
      },
    },
  }
