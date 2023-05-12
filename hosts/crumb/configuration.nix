{ lib, config, pkgs, ... }:
{
  system.stateVersion = "23.05";

  imports = [ 
    ./hardware-configuration.nix
    ../../homes/muck
    ../../homes/speck
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "crumb";
  networking.hostId = "eee65be0";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "sun12x22";
    earlySetup = true;
  };

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
      path = "/persist/keystore/sippet/id_crumb";
      type = "ed25519";
    }];
  };

  # Passwordless sudo when SSH'ing with keys
  security.pam.enableSSHAgentAuth = true;

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

  zramSwap = {
    enable = true;
    swapDevices = 1;
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
  ];
  services.xserver.enable = true;
  services.greetd = { 
   enable = true;
    settings = {
      default_session = {
        command =  "${lib.makeBinPath [pkgs.greetd.tuigreet]}/tuigreet --time --cmd 'dbus-run-session startplasma-wayland'";
      };
    };
  };
#  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5 = {
    enable = true;
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    konsole
    elisa
    gwenview
    khelpcenter
    plasma-browser-integration
  ];

  programs.dconf.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.printing.enable = true;
  services.printing.cups-pdf.enable = true;

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

  environment.systemPackages = with pkgs; [
    # Terminals
    foot
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
    # Keyboard Tools
    xcape
    # Performance Monitors
    acpi
    htop
    iotop
    iftop
    # Crypto Tools
    age
    pinentry
    pinentry-curses
    cryptsetup
    # Browsers
    qutebrowser
    # KDE Tools
    libsForQt5.bismuth
    # Greeter
    greetd.tuigreet
    # Networking
    wireguard-tools
  ];

  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];

  # CapsLock as ESC and CTRL in X11
  console.useXkbConfig = true;
#  services.xserver.xkbOptions = "caps:ctrl_modifier";
#  environment.shellInit = ''
#    xcape -e "Caps_Lock=Escape"
#  '';

  # Wireguard 
  # setup firewall to allow all traffic through
  networking.firewall = {
    # if packets are still dropped, they will show up in dmesg
    logReversePathDrops = true;
    # wireguard trips rpfilter up
    extraCommands = ''
       ${pkgs.iptables}/bin/iptables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 10017 -j RETURN
       ${pkgs.iptables}/bin/iptables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 10017 -j RETURN
    '';
    extraStopCommands = ''
       ${pkgs.iptables}/bin/iptables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 10017 -j RETURN || true
       ${pkgs.iptables}/bin/iptables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 10017 -j RETURN || true
     '';
    };

}
