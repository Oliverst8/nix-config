{
  rustPlatform,
  fetchFromGitHub,
  pkgs,
  ...
}:

rustPlatform.buildRustPackage rec {
  pname = "kittie";
  version = "0.9.0"; # you can bump this if you track a release tag

  src = fetchFromGitHub {
    owner = "avborup";
    repo = "kitty";
    rev = "master"; # or use a release tag/commit hash for reproducibility
    sha256 = "sha256-6/ednV6hpTObID8VgSxu0xw23DI9Njvz1UuGVWrQH0g="; # replace with actual hash
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  # Fix openssl-sys build
  nativeBuildInputs = [
    pkgs.pkg-config
  ];

  buildInputs = [
    pkgs.openssl
  ];

  # Helps openssl-sys locate the right paths
  PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";

  # Prevent running tests
  doCheck = false;
}
