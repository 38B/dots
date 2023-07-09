{ self, inputs, lib, pkgs, ... }:
{
  users.users.speck = {
    isNormalUser = true;
    uid = 1111;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keyFiles = [ "/persist/keystore/speck/id_speck.pub" ];
    hashedPassword =  lib.strings.fileContents /persist/keystore/speck/passhash;
    shell = pkgs.zsh;
  };

  security.sudo.extraRules = [ {
    users = ["speck"];
    commmands = [
     { command = "/bin/physlock"; options = [ "NOPASSWD" ]; }     ];
  } ];
}
