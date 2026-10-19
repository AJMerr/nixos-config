# LazyVim. lazy.nvim fetches plugins at runtime; Mason is disabled
# (nvim/lua/plugins/nix.lua), so every LSP server, formatter and debugger comes
# from home.packages below. Adding a language extra in nvim/lua/config/lazy.lua
# requires adding its tools here.
#
# init.lua and lua/ are linked individually so ~/.config/nvim stays writable
# for lazy-lock.json.
{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # --- Editor ---
    neovim

    # --- Plumbing ---
    ripgrep        # live grep
    fd             # file finder
    git            # lazy.nvim clones plugins
    lazygit        # <leader>gg
    gcc            # builds treesitter parsers
    tree-sitter    # treesitter CLI
    wl-clipboard   # Wayland clipboard

    # --- LSP servers, formatters, debuggers ---
    # Go
    go
    gopls          # LSP
    gotools        # goimports
    gofumpt        # formatter
    delve          # DAP debugger

    # Rust
    rustc
    cargo
    rust-analyzer  # LSP
    clippy         # linting
    rustfmt        # formatter

    # JavaScript / TypeScript
    nodejs
    vtsls          # TS/JS LSP
    typescript     # tsserver, used by vtsls
    prettierd      # formatter

    # HTML / CSS / JSON
    vscode-langservers-extracted

    # Markdown
    marksman           # LSP
    markdownlint-cli2  # linter

    # C / C++
    clang-tools        # clangd LSP + clang-format
    # hiPrio: gcc and clang both provide bin/cc and bin/c++; clang wins.
    (lib.hiPrio clang)
    gnumake
    cmake              # `cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON` feeds clangd
    bear               # `bear -- make` generates compile_commands.json for clangd
    gdb
    lldb
    valgrind

    # Nix
    nil                # LSP (nil_ls)
    nixfmt-rfc-style   # formatter
    statix             # linter
  ];

  # Set here so they apply when nvim is launched outside a login shell.
  home.sessionVariables = {
    EDITOR = "nvim";
    RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
  };

  xdg.configFile."nvim/init.lua".source = ./nvim/init.lua;
  xdg.configFile."nvim/lua".source = ./nvim/lua;
}
