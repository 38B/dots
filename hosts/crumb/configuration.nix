{ lib, config, pkgs, ... }:
{
  system.stateVersion = "23.05";

  imports = [ 
    ./hardware-configuration.nix
    ../../homes/speck
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "crumb";
  networking.hostId = "eee65be0";
  networking.networkmanager.enable = true;

  time.timeZone = "New_York/America";

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
  services.xserver.displayManager.sddm.enable = true;
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

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  environment.systemPackages = with pkgs; [
    neovim
    file
    wget
    curl
    btop
    lsof
    tmux
    rsync
    git
    tig
    pinentry
    pinentry-curses
    cryptsetup
    gnupg
    which
    tomb

    libsForQt5.bismuth
    qutebrowser
    kmymoney
  ];
}
