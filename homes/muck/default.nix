{ self, inputs, lib, pkgs, ... }:
{
  users.users.muck = {
    isNormalUser = true;
    uid = 1337;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keyFiles = [ "/persist/keystore/muck/id_muck.pub" ];
    hashedPassword =  lib.strings.fileContents /persist/keystore/muck/passhash;
    shell = pkgs.zsh;
  };

  security.sudo.extraRules = [ {
    users = ["muck"];
    commands = [
     { command = "${pkgs.physlock}/bin/physlock"; options = [ "NOPASSWD" ]; }
    ];
  } ];

}
