# I'll make a good README

_But not today_

Anyway, this is my nix config, a bit messy, but functionnal enough for me !

# Installing (as a self-reminder)

```bash
# Install Nix using lix installer
curl -sSf -L https://install.lix.systems/lix | sh -s -- install macos --volume-label <volume name>

# Recommended prerequisites
xcode-select --install
softwareupdate --install-rosetta --agree-to-license
sudo xcodebuild -license accept # Once Xcode is installed

# Rebuild config without darwin-rebuild cmd
export SOPS_KEY_FILE=<path to sops key> # Needed for secrets decrypt
sudo --preserve-env=SOPS_KEY_FILE nix run nix-darwin/master#darwin-rebuild -- switch \ 
    --flake <path>#<configName> \
    --impure

# Recommended
sudo reboot
```