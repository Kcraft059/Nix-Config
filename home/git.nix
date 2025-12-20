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
        signingKey = global-config.sops.secrets.ssh-id-ed25519.path;
      };
      gpg.format = "ssh";
      commit.gpgsign = true;
      gpg.ssh.allowedSignersFile = "${pkgs.writeText "allowed-signers" ''
        kcraft059.msg@gmail.com ${builtins.readFile ../ressources/ssh-id-ed25519.pub}
      ''}";
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
