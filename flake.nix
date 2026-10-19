{
  description = "AJMerr's NixOS config)";

  inputs = {
    # nixos-unstable: tested + cached rolling branch. Not a stable release,
    # not raw master.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Second nixos-unstable pin, used only for claude-code (see
    # modules/nixos/overlays.nix). Deliberately NOT `follows` nixpkgs — the
    # whole point is that it can be moved forward on its own:
    #   nix flake update nixpkgs-claude
    nixpkgs-claude.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia's own flake (v5). NOTE: v5 is not in nixpkgs yet
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, noctalia, ... }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/nixos

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.ajmerr = import ./home/ajmerr;
            }
          ];
        };
      };
    };
}
