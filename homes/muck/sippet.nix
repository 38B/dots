{ lib, config, pkgs, ... }:
{
  programs.home-manager.enable = true;
  programs.zsh.enable = true;

  home = {
    username = "muck";
    homeDirectory = "/home/muck";
    stateVersion = "23.05";
    packages = with pkgs; [ 
      neofetch
    ];
  };

  imports = [ ];
}
