{
  pkgs,
  config,
  global-config,
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
        #identityFile = "~/.ssh/FTN-ed25519";
        identityFile = "${global-config.sops.secrets."ftn/front-ssh".path}";
      };
      FTN-Server-Node = {
        port = 22;
        hostname = "10.0.0.2";
        user = "server";
        proxyJump = "FTN-Server";
        #identityFile = "~/.ssh/FTN-node-ed25519";
        identityFile = "${global-config.sops.secrets."ftn/node-ssh".path}";
      };
      FTN-Camille = {
        port = 22;
        hostname = "ftnetwork.duckdns.org";
        user = "camille";
        identityFile = "${global-config.sops.secrets."ftn/node-ssh".path}";
        #identityFile = "~/.ssh/FTN-ed25519";
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
