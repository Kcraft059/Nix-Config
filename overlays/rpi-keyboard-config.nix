{
  lib,
  python3Packages,
  fetchFromGitHub,
  hidapi,
  ...
}:

python3Packages.buildPythonPackage rec {
  pname = "rpi-keyboard-config";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "rpi-keyboard-config";
    rev = "v${version}"; # or a commit hash
    hash = "sha256-/r4Rv3FkWulsYHb/q1ymf+7wNzSQbTDVSOa8QgH/cyk=";
  };

  format = "setuptools";

  # Runtime dependencies (adjust after checking imports)
  propagatedBuildInputs = [
    hidapi
  ];

  # No tests upstream
  doCheck = false;

  pythonImportsCheck = [
    "RPiKeyboardConfig"
  ];

  meta = with lib; {
    description = "RPi Keyboard configuration utility";
    homepage = "https://github.com/raspberrypi/rpi-keyboard-config";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
