{
  pkgs,
  inputs,
  lib ? pkgs.lib,
}:
let
  # Import nixpkgs with rust-overlay to access rust-bin nightly toolchains
  pkgsWithRust = import inputs.nixpkgs {
    system = pkgs.stdenv.hostPlatform.system;
    overlays = [ (import inputs.rust-overlay) ];
  };

  toolchain = pkgsWithRust.rust-bin.stable."1.90.0".default.override {
    extensions = [
      "rust-src"
      "clippy"
      "rustfmt"
    ];
  };

  craneLib = (inputs.crane.mkLib pkgsWithRust).overrideToolchain toolchain;

  src = inputs.rift;

  commonArgs = {
    pname = "rift";
    version = src.rev or "unstable";
    src = lib.cleanSourceWith {
      src = inputs.rift;
      filter =
        path: type: (craneLib.filterCargoSources path type) || (lib.hasSuffix "assets/Info.plist" path);
    };
    buildInputs = [ ];
    doCheck = false; # disable tests for now
  };

  cargoArtifacts = craneLib.buildDepsOnly commonArgs;

in
craneLib.buildPackage (commonArgs // { cargoArtifacts = cargoArtifacts; })
