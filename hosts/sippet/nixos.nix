{ lib, config, pkgs, ... }:
{
  system.stateVersion = "23.05";

  hardware.cpu.amd.updateMicrocode = false;
  
  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

}
