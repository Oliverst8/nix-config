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
    owner = "nilotpalbiswas";
    repo = "MacOS-Boot-Plymouth";
    rev = "b915d00da75fce6559157da9187331bac14144aa";
    hash = "sha256-rTn/btgy3MHHyfcblxrQRVssksNNjvF5p0nDyVQpScI="; # You'll need to update this hash
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

  meta = {
    description = "MacOS-inspired Plymouth boot theme";
    longDescription = ''
      A Plymouth boot theme inspired by the MacOS boot animation.
    '';
    homepage = "https://github.com/nilotpalbiswas/MacOS-Boot-Plymouth";
    license = lib.licenses.unfree; # No license specified in the repository
    platforms = lib.platforms.linux;
  };
}
