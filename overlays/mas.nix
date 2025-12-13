# Override Package
final: prev: {
  mas = prev.mas.overrideAttrs (oldAttrs: rec {
    version = "2.0.0";
    src = prev.fetchurl {
      url = "https://github.com/mas-cli/mas/releases/download/v${version}/mas-${version}.pkg";
      hash = "sha256-/8w5cCUZF5jgmKTZHfevnBdNE3ChC759yV5WsZmGw6g=";
    };
  });
}
