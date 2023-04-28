{ lib, config, pkgs, system, ... }:
{
  boot = {
    kernelModules = [ "kvm-amd" "r8169" ];
    blacklistedKernelModules = [ "rtw88_8822ce" "btusb" ]; 
    kernelParams = [ "elevator=none" "radeon.si_support=0" "amdgpu.si_support=1" ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "ahci" "usb_storage" "uas" "sd_mod" ];
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
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "zfs" "ntfs" ];
    zfs.devNodes = "/dev/disk/by-label/sippet-os";
  };  
}
