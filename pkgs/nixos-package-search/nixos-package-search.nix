{
  lib,
  rustPlatform,
  pkgs,
  sources,
  ...
}:

let
  runtimeLibs = with pkgs; [
    libGL
    libxkbcommon
    wayland
    libx11
    libxcursor
    libxi
    libxrandr
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "nixos-package-search";
  version = "0.1.0";

  src = sources.nixos-package-search;

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  nativeBuildInputs = [
    pkgs.pkg-config
    pkgs.makeWrapper
  ];
  # aws-lc-sys honours the hook's AWS_LC_SYS_USE_SYSTEM, so it needs the real library.
  buildInputs = runtimeLibs ++ [ pkgs.aws-lc ];

  postFixup = ''
    wrapProgram $out/bin/nixos-package-search \
      --set LD_LIBRARY_PATH ${lib.makeLibraryPath runtimeLibs} \
      --prefix PATH : ${
        lib.makeBinPath [
          pkgs.nix
          pkgs.util-linux
        ]
      }
  '';

  meta = {
    description = "Search-as-you-type popup for nixpkgs packages, launch via nix shell";
    mainProgram = "nixos-package-search";
  };
}
