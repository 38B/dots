{ lib, config, pkgs, ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
      ../../homes/blob
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "sippet";
  networking.networkmanager.enable = false;  # Easiest to use and most distros use this by default.
  networking.networkmanager.unmanaged = [ "wlp3s0" ];

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "sun12x22";
    earlySetup = true;
  };

  services.xserver.enable = false;
  services.xserver.videoDrivers = [ "amdgpu" ];

  environment.systemPackages = with pkgs; [
    # Terminal Tools
    neovim 
    tmux
    # File Tools
    file
    lsof
    which
    xz
    lz4
    zstd
    zip
    unzip
    # Download Tools
    wget
    curl
    rsync
    git
    # Performance Monitors
    acpi
    htop
    iotop
    iftop
    # Crypto Tools
    age
    pinentry
    pinentry-curses
    # Browser
    w3m
    # Services
    syncthing
  ];

  services.openssh = {
    enable = true;
    settings = {
      # Harden
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      GatewayPorts = "clientspecified";
    };
    # Automatically remove stale sockets
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';

    hostKeys = [{
      path = "/keystore/sippet/id_sippet";
      type = "ed25519";
    }];
  };

  # Passwordless sudo when SSH'ing with keys
  security.pam.enableSSHAgentAuth = true;

  system.stateVersion = "23.05";
  
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

  networking.hostId = "3f871983";
  boot.supportedFilesystems = [ "zfs" "ntfs" ];
  boot.kernelParams = [ "elevator=none" "radeon.si_support=0" "amdgpu.si_support=1" ];
  boot.zfs.devNodes = "/dev/disk/by-label/sippet-os";

   zramSwap = {
    enable = true;
    swapDevices = 1;
  };

  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];

  documentation.enable = true;
  documentation.nixos.enable = false;
  documentation.man.enable = true;
  documentation.info.enable = false;
  documentation.doc.enable = false;

  # Don't wait for network startup
  # https://old.reddit.com/r/NixOS/comments/vdz86j/how_to_remove_boot_dependency_on_network_for_a
  systemd = {
    targets.network-online.wantedBy = pkgs.lib.mkForce []; # Normally ["multi-user.target"]
    services.NetworkManager-wait-online.wantedBy = pkgs.lib.mkForce []; # Normally ["network-online.target"]
  };
  
  services.logind.extraConfig = ''
    HandleLidSwitch=ignore
    HandleLidSwitchExternalPower=ignore
  '';

  boot = {
    initrd = {
      network = {
        enable = true;
        ssh = {
          enable = true;
          hostKeys = [ /keystore/sippet/id_sippet_init ];
          authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmo4gVcs6I/wmpjURsZNVo63/nRfdp80rZv4wxg8Y2y" ];
          port = 2223;
        };
        udhcpc.extraArgs = [ "-t 10" ];
      };
      kernelModules = [ "amdgpu" "r8169" ];
      postDeviceCommands = lib.mkAfter ''
        zfs rollback -r sippet-os/ephemeral/slash@blank
      '';
    };
  };  
  
  networking.firewall = {
    allowedUDPPorts = [ 10071 ];
  };

  networking.wg-quick.interfaces = let
    publicKey = "Aa1Z+ityCCLGIw7tbKP1F1RfSJ2zTM/D3BT6ktj2gmo=";
  in {
    wg0 = {
      address = [ "10.10.100.10/32" ];
      listenPort = 10071;
      privateKeyFile = "/keystore/sippet/wg_sippet";
      postUp = ''
        ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.1/24 -o eth0 -j MASQUERADE
        wg set wg0 peer ${publicKey} persistent-keepalive 25;
      '';
      preDown = ''
        ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.1/24 -o eth0 -j MASQUERADE
      '';
      peers = [
        {
          inherit publicKey;
          allowedIPs = [ "0.0.0.0/0" ];
          # Or forward only particular subnets
          #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];
          endpoint = "exit66.duckdns.org:10071";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      interface = "wg0";
      server = [ "9.9.9.9" "149.112.112.112" ];
    };
  };
}
