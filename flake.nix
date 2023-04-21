{
  description = "a collection of my system, user, and shell delarations";

  inputs = {

    # NixOS Generators
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Flake Parts
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    nixpkgs,
    nixos-generators,
    nixos-hardware,
    home-manager,
    ...
  }:
    (flake-parts.lib.evalFlakeModule
      {inherit inputs;}
      {
        imports = [
          ./hosts
      	  ./homes
	        ./shells
        ];
	      
        systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
        
        perSystem = {
          config,
          inputs',
          system,
          ...
        }: {
          # make pkgs available to all `perSystem` functions
          _module.args.pkgs = inputs'.nixpkgs.legacyPackages;
        };

        pkgs.x86_64-linux = {
          crumbiso = nixos-generators.nixosGenerate {
            system = "x86_64-linux";
            modules = [
              ./hosts/crumb/configuration.nix
            ];
            format = "iso";
	        };
        };

        # CI
        flake.hydraJobs = let
          inherit (nixpkgs) lib;
          buildHomeManager = arch:
            lib.mapAttrs' (name: config: lib.nameValuePair "home-manager-${name}-${arch}" config.activation-script) self.legacyPackages.${arch}.homeConfigurations;
        in
          (lib.mapAttrs' (name: config: lib.nameValuePair "nixos-${name}" config.config.system.build.toplevel) self.nixosConfigurations)
          // (buildHomeManager "x86_64-linux")
          // (buildHomeManager "aarch64-linux")
          // (buildHomeManager "aarch64-darwin")
          // {
          };
      })
    .config
    .flake;
}
