{ lib, config, pkgs, ... }:
{
  programs.home-manager.enable = true;
  programs.zsh.enable = true;

  home = {
    username = "speck";
    homeDirectory = "/home/speck";
    stateVersion = "23.05";
    packages = with pkgs; [ 
      neofetch
    ];
  };

  imports = [ ];
}
