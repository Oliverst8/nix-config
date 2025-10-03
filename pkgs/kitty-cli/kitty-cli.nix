{
  rustPlatform,
  pkgs,
  sources,
  ...
}:

rustPlatform.buildRustPackage rec {
  pname = "kitty";
  version = "0.9.0";

  src = sources.kitty;

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  postInstall = ''
    mv "$out/bin/kitty" "$out/bin/kittie"
  '';

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ pkgs.openssl ];
  PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";

  doCheck = false;
}
