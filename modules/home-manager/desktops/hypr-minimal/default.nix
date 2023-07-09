{ lib, config, pkgs, hyprland, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
  };
  
  home.packages = with pkgs; [
    sirula
    mc
    hyprpaper
    btop
    swaylock
    swayidle
    wlogout
    mako
  ];

  xdg.configFile.hypr = {
    source = ./hypr;
    recursive = true;
  };

  xdg.dataFile."wallpapers/nixos-ice.png" = {
    source = ./nixos-ice.png;
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "monospace:size=12";
        pad = "12x12";
      };
      colors = {
        alpha = "0.9";
        foreground = "78796f";
        background = "373b43";
        regular0 = "373b43";
        bright0 = "373b43";
        regular1 = "fdcd39";
        bright1 = "fdcd39";
        regular2 = "fbfd59";
        bright2 = "fbfd59";
        regular3 = "deac40";
        bright3 = "deac40";
        regular4 = "afb171";
        bright4 = "afb171";
        regular5 = "b387e7";
        bright5 = "b387e7";
        regular6 = "63e860";
        bright6 = "63e860";
        regular7 = "efdecb";
        bright7 = "efdecb";
      };
    };
  };

  programs.zsh = {
    shellAliases = {
      hypr = "Hyprland -c ~/.local/etc/hypr/hyprland.conf";
    };
  };

  wayland.windowManager.sway.enable = true; # needed for swaylock

}
