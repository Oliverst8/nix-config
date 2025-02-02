{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gottis";
  version = "0.1.0"; # Adjust based on upstream tags

  src = fetchFromGitHub {
    owner = "oliverst8";
    repo = "gottis";
    rev = "main"; # Use a specific commit or tag for stability
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Replace with the correct hash
  };

  vendorHash = "sha256-BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB="; # Replace with the correct hash

  meta = with lib; {
    description = "A Go-based TUI system information tool";
    homepage = "https://github.com/oliverst8/gottis";
    license = licenses.mit; # Adjust if different
    maintainers = with maintainers; [ oliverst8 ];
  };
}

