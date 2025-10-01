{ inputs, ... }:
{
  imports = [ inputs.LazyVim.homeManagerModules.default ];

  stylix.targets.neovim.enable = false;

  programs.neovim = {
    enable = true;
  };

  programs.lazyvim = {
    enable = true;
    extras = {
      lang = {
        nix.enable = true;
        #markdown.enable = true;
      };
    };
  };
}
