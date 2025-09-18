{
  rustPlatform,
  fetchFromGitHub,
  pkgs,
  ...
}:

rustPlatform.buildRustPackage rec {
  pname = "kitty";
  version = "0.9.0"; # you can bump this if you track a release tag

  src = fetchFromGitHub {
    owner = "oliverst8";
    repo = "kittie";
    rev = "feat/contest"; # or use a release tag/commit hash for reproducibility
    sha256 = "sha256-6ua7zA2X0ftf3OLJyBGgSDFkgqsqiOqz1Pt2rWe6cck="; # replace with actual hash
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  postInstall = ''
    mv "$out/bin/kitty" "$out/bin/kittie"
  '';

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
