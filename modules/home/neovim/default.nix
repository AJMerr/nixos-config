# Neovim, configured as LazyVim.
#
# The NixOS reality of LazyVim (read before touching this):
#
#   LazyVim is a lazy.nvim distribution. lazy.nvim manages *plugins* (pure Lua
#   / Vimscript cloned into ~/.local/share/nvim/lazy) — that works fine here.
#   But LazyVim also leans on **Mason** to install LSP servers, formatters and
#   debuggers as pre-built binaries. Those binaries are dynamically linked
#   against FHS paths (/lib64/ld-linux..., /usr/lib) that do not exist on
#   NixOS, so Mason installs then crash at runtime. The fix everyone converges
#   on: **disable Mason** and hand LazyVim every tool from Nix instead, on
#   $PATH. That disabling happens in nvim/lua/plugins/nix.lua; the tools are
#   the `home.packages` list below. The two halves are a matched pair — if you
#   add a language extra in nvim/lua/config/lazy.lua, add its server/formatter
#   here too, or it silently won't start.
#
# Config lives in-repo under ./nvim and is symlinked into ~/.config/nvim (same
# philosophy as the Hyprland Lua: edit here, rebuild, changes hash into the
# store). We link init.lua and the lua/ tree *individually* rather than linking
# the whole nvim/ directory, on purpose: that leaves ~/.config/nvim a real,
# writable directory so lazy.nvim can still create lazy-lock.json inside it.
{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # --- Neovim itself -----------------------------------------------------
    # (hosts/nixos also ships neovim as a first-boot bootstrap editor; Nix
    # dedupes the identical store path, so declaring it here for a
    # self-contained module costs nothing.)
    neovim

    # --- Editor plumbing LazyVim shells out to -----------------------------
    ripgrep        # telescope live-grep, LazyVim <leader>/ etc.
    fd             # fast file finder for telescope
    git            # lazy.nvim clones plugins over git on first launch
    lazygit        # <leader>gg git UI integration
    gcc            # C compiler nvim-treesitter uses to build parsers at runtime
    tree-sitter    # treesitter CLI (parser generation for a few grammars)
    wl-clipboard   # wl-copy/wl-paste — system clipboard on Wayland/Hyprland

    # --- LSP servers, formatters, debuggers (Mason's job, done by Nix) -----
    # Go
    go
    gopls          # LSP
    gotools        # goimports
    gofumpt        # formatter (LazyVim go extra)
    delve          # DAP debugger

    # Rust  (rustaceanvim finds rust-analyzer + the toolchain on $PATH)
    rustc
    cargo
    rust-analyzer  # LSP
    clippy         # linting
    rustfmt        # formatter

    # JavaScript / TypeScript  (LazyVim's typescript extra drives vtsls)
    nodejs
    vtsls          # TS/JS LSP
    typescript     # tsserver library vtsls resolves against
    prettierd      # formatter for js/ts/css/html/markdown/json

    # HTML / CSS / JSON  (one package = vscode-html/css/json/eslint servers)
    vscode-langservers-extracted

    # Markdown
    marksman           # LSP
    markdownlint-cli2  # linter (LazyVim markdown extra)

    # C / C++
    clang-tools        # clangd LSP + clang-format
  ];

  # Neovim as the default editor, and point rust-analyzer at the std library
  # source so "go to definition" into std works even when nvim is launched
  # outside a login shell (e.g. from a Hyprland keybind).
  home.sessionVariables = {
    EDITOR = "nvim";
    RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
  };

  # Symlink the LazyVim config in. Individual entries (not the whole nvim/
  # dir) so ~/.config/nvim stays writable for lazy-lock.json — see header.
  xdg.configFile."nvim/init.lua".source = ./nvim/init.lua;
  xdg.configFile."nvim/lua".source = ./nvim/lua;
}
