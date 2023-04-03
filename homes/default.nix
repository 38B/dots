{ self, inputs, ... }:
{
  # Available through 'home-manager --flake .#your-username@your-hostname'
  flake = {
    homeConfigurations = {
      "blob@sippet" = inputs.home-manager.lib.homeManagerConfiguration {
        modules = [
          ./blob/sippet.nix
        ];
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      };
    };
  };
}
