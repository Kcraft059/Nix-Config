echo "For nix-darwin Don't use determinate Nix"
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
 sh -s -- install macos \
 --volume-label 'Nix Store Alt'
# See https://github.com/DeterminateSystems/nix-installer For options
# `/nix/nix-installer uninstall for a complete removal`