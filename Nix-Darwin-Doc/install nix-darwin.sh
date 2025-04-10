nix run nix-darwin/master#darwin-rebuild -- switch
# Don't change the command, it's meant to be a distant file not a local file
# Once ran darwin-rebuild switch --flake path/to/flake/dir#ConfigurationName
# If there's no flake `nix flake init -t nix-darwin/master`