{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.ssh.enable = true;
  programs.ssh.matchBlocks = {
    FTN-Server = {
      port = 22;
      hostname = "ftnetwork.duckdns.org";
      user = "server";
      identityFile = "~/.ssh/FTN-ed25519";
    };
    FTN-Camille = {
      port = 22;
      hostname = "ftnetwork.duckdns.org";
      user = "camille";
      identityFile = "~/.ssh/FTN-ed25519";
    };
  };
}
