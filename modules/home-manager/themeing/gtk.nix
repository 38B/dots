{ lib, config, pkgs, hyprland, ... }:
{

  gtk {
    enable = true;
    cursorTheme = {
      package = pkgs.numix-cursor-theme;
      name = "Numix-Cursor";
      size = 16;
    };
    /* TODO font = {}; */
    iconTheme = {
      package = pkgs.moka-icon-theme;
      name = "Moka";
    };
    theme = {
      package = pkgs.gruvbox-dark-gtk;
      name = "gruvbox-dark";
    };
  };

}
