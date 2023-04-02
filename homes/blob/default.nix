{ self, inputs, ... }:
{
  users.users.blob = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ "/persist/keystore/blob/id_blob.pub" ];
    passwordFile = "/persist/keystore/blob/passhash";
  };
}
