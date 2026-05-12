{ global-config, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      FTN-Server = {
        port = 22;
        hostname = "ftnetwork.duckdns.org";
        user = "server";
        identityFile = "${global-config.sops.secrets."ftn/front-ssh".path}";
        addKeysToAgent = "yes";
        extraOptions = {
          UseKeychain = "yes";
        };
      };
      FTN-Server-Node = {
        port = 22;
        hostname = "10.0.0.2";
        user = "server";
        proxyJump = "FTN-Server";
        identityFile = "${global-config.sops.secrets."ftn/node-ssh".path}";
        addKeysToAgent = "yes";
        extraOptions = {
          UseKeychain = "yes";
        };
      };
      FTN-Camille = {
        port = 22;
        hostname = "ftnetwork.duckdns.org";
        user = "camille";
        identityFile = "${global-config.sops.secrets."ftn/front-ssh".path}";
        addKeysToAgent = "yes";
        extraOptions = {
          UseKeychain = "yes";
        };
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
    extraConfig = "IgnoreUnknown UseKeychain";
  };
}
