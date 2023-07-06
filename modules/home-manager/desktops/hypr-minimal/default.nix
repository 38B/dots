{ lib, config, pkgs, hyprland, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
  };
  
  home.packages = with pkgs; [
    sirula
    mc
    hyprpaper
  ];

  xdg.configFile.hypr = {
    source = ./hypr;
    recursive = true;
  };

  xdg.dataFile."wallpapers/nixos-ice.png" = {
    source = ./nixos-ice.png;
  };
}
