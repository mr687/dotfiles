return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      vtsls = {
        settings = {
          complete_function_calls = true,
          vtsls = {
            experimental = {
              documentSymbol = {
                enable = true,
                fallback = true, -- optionally fallback to typescript-language-server style
              },
            },
          },
        },
      },
      tailwindcss = {
        settings = {
          tailwindCSS = {
            classFunctions = { "cva", "cx" },
          },
        },
      },
    },
  },
}
