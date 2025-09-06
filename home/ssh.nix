{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
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
      "*" = {
        forwardAgent = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        compression = false;
        addKeysToAgent = "no";
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
    };
  };
}
