{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gottis";
  version = "0.1.0"; # Adjust based on upstream tags

  src = fetchFromGitHub {
    owner = "oliverst8";
    repo = "gottis";
    rev = "main"; # Use a specific commit or tag for stability
    sha256 = "sha256-g9na43fioXW1OJAPI6AxwTVjTNeLN/Y4/AZiLAtKw0E="; # Replace with the correct hash
  };

  vendorHash = null;

  meta = with lib; {
    description = "A Go-based TUI system information tool";
    homepage = "https://github.com/oliverst8/gottis";
    license = licenses.mit;
    maintainers = with maintainers; [ oliverst8 ];
  };
}
