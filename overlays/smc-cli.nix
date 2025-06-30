self: super:
{
  menubar-cli = super.stdenv.mkDerivation {
    name = "smc-cli";
    version = "2.6";

    src = super.fetchFromGitHub {
      owner = "hholtmann";
      repo = "smcFanControl";
      rev = version;
      sha256 = "sha256-1z4h1izcr0bm48bc5y8cqq1c8bq02bhdlvi4lp53nbdsz09pxb9i="; # Replace this with the actual one
    };
    nativeBuildInputs = [ super.gcc ]; # or gcc if needed

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