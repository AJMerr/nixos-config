# Git + GitHub CLI, with gh as the HTTPS credential helper.
#
# user.name/user.email are not set here (this repo is public). Create the
# untracked include file on each machine:
#   git config --file ~/.config/git/identity user.name  "Your Name"
#   git config --file ~/.config/git/identity user.email "you@example.com"
#
# Delete any ~/.gitconfig; it overrides ~/.config/git/config. The gh login
# token is stored in ~/.config/gh/hosts.yml (`gh auth login`), not here.
{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    includes = [ { path = "~/.config/git/identity"; } ];
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings.git_protocol = "https";
  };
}
