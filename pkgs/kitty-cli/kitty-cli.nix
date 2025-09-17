{
  rustPlatform,
  fetchFromGitHub,
  ...
}:

rustPlatform.buildRustPackage rec {
  pname = "kittie";
  version = "0.9.0"; # you can bump this if you track a release tag

  src = fetchFromGitHub {
    owner = "avborup";
    repo = "kitty";
    rev = "main"; # or use a release tag/commit hash for reproducibility
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # replace with actual hash
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };
}
