self: super: {
  smc-cli = super.stdenv.mkDerivation rec {
    name = "smc-cli";
    version = "master";

    src = super.fetchFromGitHub {
      owner = "hholtmann";
      repo = "smcFanControl";
      rev = version;
      sha256 = "sha256-Ma1+E/i6LTvKpSRu2uASAC/EAsYM+cIWInWBzH4MkPw=";
    };
    nativeBuildInputs = [
      super.gcc
      super.darwin.apple_sdk.frameworks.IOKit
      super.darwin.apple_sdk.frameworks.CoreFoundation
    ];

    buildPhase = ''
      cd smc-command
      make
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp smc $out/bin/
    '';
  };
}
