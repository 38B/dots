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
      
      "muck@crumb" = inputs.home-manager.lib.homeManagerConfiguration {
        modules = [
          ./muck/crumb.nix
        ];
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      };

       "speck@crumb" = inputs.home-manager.lib.homeManagerConfiguration {
        modules = [
          hyprland.homeManagerModules.default
          {wayland.windowManager.hyprland.enable = true;}
          ./speck/crumb.nix
        ];
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      };
   };
  };
}
