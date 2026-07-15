-- Neovim entry point. Bootstraps lazy.nvim + LazyVim (lua/config/lazy.lua).
--
-- This file (and everything under lua/) is managed by home-manager
-- (modules/home/neovim) and symlinked read-only from the Nix store. Edit the
-- copy in the repo and `nixos-rebuild switch`, not this symlink.
require("config.lazy")
