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
      identityFile = builtins.readFile(./ressources/credentials/FTN-ssh-key);
    };
  };
}
