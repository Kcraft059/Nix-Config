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

# Install sops age key from ssh-id
nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i <path to ssh id> > <path to sops key>"

# Rebuild config without darwin-rebuild cmd
export SOPS_KEY_FILE=<path to sops key> # Needed for secrets decrypt
sudo --preserve-env=SOPS_KEY_FILE nix run nix-darwin/master#darwin-rebuild -- switch \ 
    --flake <path>#<configName> \
    --impure

# Recommended
sudo reboot
```

# Configuring 

Secrets editing
```bash
# Get public key
nix-shell -p age --run "age-keygen -y <path to sops key>"

# Edit secrets
export SOPS_AGE_KEY_FILE=<path to file with keys>
nix-shell -p sops --run "sops <secrets path>"

# Update keys from .sops.yaml
nix-shell -p sops --run "sops updatekeys <secrets path>"
```

# Styling 

**EnclosureNumbers colors:**

| Int  | Hex        | Color                               |
| ---- | ---------  | ----------------------------------- |
| -2   | multicolor | $${\color{#0059D1}{\blacksquare}}$$ |
| -1   | `#8C8C8C`  | $${\color{#8C8C8C}{\blacksquare}}$$ |
| 0    | `#F04F55`  | $${\color{#F04F55}{\blacksquare}}$$ |
| 1    | `#F7821B`  | $${\color{#F7821B}{\blacksquare}}$$ |
| 2    | `#FFC600`  | $${\color{#FFC600}{\blacksquare}}$$ |
| 3    | `#62BA46`  | $${\color{#62BA46}{\blacksquare}}$$ |
| 4    | `#007AFF`  | $${\color{#007AFF}{\blacksquare}}$$ |
| 5    | `#A550A7`  | $${\color{#A550A7}{\blacksquare}}$$ |
| 6    | `#F74F9E`  | $${\color{#F74F9E}{\blacksquare}}$$ |
| 9    | `#F3B036`  | $${\color{#F3B036}{\blacksquare}}$$ |
| 10   | `#427E82`  | $${\color{#427E82}{\blacksquare}}$$ |
| 11   | `#507790`  | $${\color{#507790}{\blacksquare}}$$ |
| 12   | `#CD565A`  | $${\color{#CD565A}{\blacksquare}}$$ |
| 13   | `#5D6291`  | $${\color{#5D6291}{\blacksquare}}$$ |
| 14   | `#EF8056`  | $${\color{#EF8056}{\blacksquare}}$$ |
| 15   | `#98A8D9`  | $${\color{#98A8D9}{\blacksquare}}$$ |
| 16   | `#B5D65A`  | $${\color{#B5D65A}{\blacksquare}}$$ |
| 16   | `#F77F9A`  | $${\color{#F77F9A}{\blacksquare}}$$ |