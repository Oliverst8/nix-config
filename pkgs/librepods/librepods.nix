{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  openssl,
  pulseaudio,
  pkg-config,
  sources,
}:

stdenv.mkDerivation rec {
  pname = "librepods";
  version = "0.1.0-rc.4";

  src = fetchFromGitHub {
    owner = "kavishdevar";
    repo = "librepods";
    rev = "v${version}"; # or use a specific commit hash
    hash = ""; # Run nix-build first to get the correct hash
  };

  sourceRoot = "${src.name}/linux";

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtconnectivity # For Bluetooth
    openssl
    pulseaudio
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  meta = with lib; {
    description = "AirPods liberated from Apple's ecosystem";
    homepage = "https://github.com/kavishdevar/librepods";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Oliverst8 ];
    platforms = platforms.linux;
    mainProgram = "librepods";
  };
}
