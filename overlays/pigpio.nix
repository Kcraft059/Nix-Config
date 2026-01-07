{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "pigpio";
  version = "79"; # example

  src = fetchFromGitHub {
    owner = "joan2937";
    repo = "pigpio";
    rev = "v${version}";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  buildPhase = ''
    make lib
  '';

  installPhase = ''
    mkdir -p $out/lib $out/include

    install -m 0755 libpigpio.so.1      $out/lib/
    install -m 0755 libpigpiod_if.so.1  $out/lib/
    install -m 0755 libpigpiod_if2.so.1 $out/lib/

    ln -s libpigpio.so.1      $out/lib/libpigpio.so
    ln -s libpigpiod_if.so.1  $out/lib/libpigpiod_if.so
    ln -s libpigpiod_if2.so.1 $out/lib/libpigpiod_if2.so

    install -m 0644 pigpio.h      $out/include/
    install -m 0644 pigpiod_if.h  $out/include/
    install -m 0644 pigpiod_if2.h $out/include/
  '';

  /* # prevent ldconfig execution
  patchPhase = ''
    substituteInPlace Makefile \
      --replace "ldconfig" "true"
  '';

  # pigpio Makefile hardcodes /usr/local
  makeFlags = [
    "prefix=$(out)"
  ];

  # We only want the C lib + headers
  installTargets = [ "install" ];

  # Prevent python installs + ldconfig
  postInstall = ''
    # Remove Python bindings
    rm -rf $out/lib/python*
    rm -rf $out/lib/site-packages

    # Remove binaries & daemon
    rm -rf $out/bin
    rm -rf $out/sbin
    rm -rf $out/opt

    # Remove man pages
    rm -rf $out/share
  ''; */

  meta = with lib; {
    description = "C library for GPIO control on Raspberry Pi";
    homepage = "http://abyz.me.uk/rpi/pigpio/";
    license = licenses.unfreeRedistributableFirmware; # pigpio is weirdly licensed
    platforms = platforms.linux;
  };
}
