{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "plymouth-macos-theme";
  version = "0-unstable-2020-02-16";

  src = fetchFromGitHub {
    owner = "oliverst8";
    repo = "MacOS-sus-Boot-Plymouth";
    rev = "06d67a53bdcdfda7286dab36a8780b97b04b5d32";
    hash = "sha256-+DQe+Xco7FWtPwgEe9AWPLAnSw2+Ptk9VEQtieI01uY="; # You'll need to update this hash
  };

  postPatch = ''
    # Remove not needed files
    rm -f README.md
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plymouth/themes/apple-mac-plymouth
    cp -r apple-mac-plymouth/* $out/share/plymouth/themes/apple-mac-plymouth/
    find $out/share/plymouth/themes/ -name \*.plymouth -exec sed -i "s@\/usr\/@$out\/@" {} \;
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

}
