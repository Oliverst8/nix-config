{
  lib,
  buildGoModule,
  sources,
}:

buildGoModule rec {
  pname = "gottis";
  version = "0.1.0"; # Adjust based on upstream tags

  src = sources.gottis;

  vendorHash = null;

  meta = with lib; {
    description = "A Go-based TUI system information tool";
    homepage = "https://github.com/oliverst8/gottis";
    license = licenses.mit;
    maintainers = with maintainers; [ oliverst8 ];
  };
}
