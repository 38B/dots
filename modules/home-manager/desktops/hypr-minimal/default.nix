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
    swayidle
    wlogout
    mako
    wofi
  ];

  xdg.configFile.hypr = {
    source = ./hypr;
    recursive = true;
  };

  xdg.dataFile."wallpapers/earthmap.png" = {
    source = ./earthmap.png;
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

  programs.wlogout = {
    layout = [
      {
        label = "lock-wl";
        action = "sudo physlock -dsm";
        text = "LOCK";
        keybind = "l";
      }
      {
        label = "logout-wl";
        action = "loginctl terminate-user $USER";
        text = "LOGOUT";
        keybind = "L";
      }
      {
        label = "shutdown-wl";
        action = "systemctl shutdown";
        text = "SHUTDOWN";
        keybind = "s";
      }
      {
        label = "reboot-wl";
        action = "systemctl reboot";
        text = "REBOOT";
        keybind = "r";
      }
    ];
    enable = true;
  };
}
