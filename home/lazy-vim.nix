{ inputs, ... }:
{
  #imports = [ inputs.LazyVim.homeManagerModules.default ];

  stylix.targets.neovim.enable = false;

  programs.neovim = {
    enable = true;
  };

  /* programs.lazyvim = {
    enable = false;
    extras = {
      lang = {
        nix.enable = true;
        #markdown.enable = true;
      };
    };
  }; */
}
