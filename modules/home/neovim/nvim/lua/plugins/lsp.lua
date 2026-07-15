-- HTML / CSS language support.
--
-- LazyVim ships no dedicated html/css "extra", so we register the servers
-- ourselves. The binaries (vscode-html-language-server,
-- vscode-css-language-server) come from vscode-langservers-extracted in Nix;
-- with Mason disabled, LazyVim sets these up straight through nvim-lspconfig
-- and starts them from $PATH.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {},
        cssls = {},
      },
    },
  },
  -- Ensure the matching treesitter parsers are built (via the Nix `gcc`).
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "html", "css" })
    end,
  },
}
