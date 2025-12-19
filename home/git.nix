{
  pkgs,
  lib,
  config,
  global-config,
  ...
}:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "kcraft059.msg@gmail.com";
        name = "Kcraft059";
        #signingKey = ${config.sops.ssh-id-ed25519.path};
      };
      #signing.format = "ssh";
      url."git@github.com:".insteadOf = "https://github.com/";
    };
    ignores = [
      "*~"
      ".DS_Store"
    ];
  };

  programs.ssh.matchBlocks."github.com" = {
    identityFile = "${global-config.sops.secrets.ssh-id-ed25519.path}";
  };
}
