{
  description = "NixOS + Home Manager monorepo (Misterio77-style layout)";

  inputs = {
    # nixos-unstable: tested + cached rolling branch. Not a stable release,
    # not raw master.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia's own flake (v5). NOTE: v5 is not in nixpkgs yet — first
    # build compiles from source unless you use their Cachix cache, which
    # requires REMOVING the follows line below (following nixpkgs changes
    # the derivation hash -> cache miss). See README "Noctalia flags".
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
        legion-tower-5 = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/legion-tower-5

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.austin = import ./home/austin;
            }
          ];
        };
      };
    };
}
