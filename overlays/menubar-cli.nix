self: super:
{
  menubar-cli = super.stdenv.mkDerivation {
    name = "menubar-cli";
    version = "1.0";

    src = ./src/menubar-cli;  # Or fetchFromGitHub if remote

    nativeBuildInputs = [ super.clang ]; # or gcc if needed

    buildPhase = ''
      make
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp bin/menubar $out/bin/
    '';
  };
}