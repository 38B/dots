{ lib, config, pkgs, ... }:
{
  networking = {
    hostName = "sippet";
    hostId = "3f871983";
    networkmanager = { 
      enable = false;
      unmanaged = [ "wlp3s0" ];
    };
    useDHCP =  false;
    interfaces.enp2s0.useDHCP = true;
  };

  # Don't wait for network startup
  # https://old.reddit.com/r/NixOS/comments/vdz86j/how_to_remove_boot_dependency_on_network_for_a
  systemd = {
    targets.network-online.wantedBy = pkgs.lib.mkForce []; # Normally ["multi-user.target"]
    services.NetworkManager-wait-online.wantedBy = pkgs.lib.mkForce []; # Normally ["network-online.target"]
  };
 
}
