{ self, inputs, ... }:
{
  users.users.blob = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    # password = "";
  };
}
