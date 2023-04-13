# ZFS tools for NixOS Install
Step 1: Boot NixOS install iso

Step 2: Enable flakes and install git

```
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
nix-env -f '<nixpkgs>' -iA git
```

Step 3: Clone this repository

Step 4: Copy the zfs-install directory and customize to your needs

Step 5: Start at script 00 and work your way through in order.

Note: These scripts are a base that I use and are customized further for each machine.
