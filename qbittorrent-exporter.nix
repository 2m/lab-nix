{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "qbittorrent-exporter";
  version = "1.13.2";

  src = fetchFromGitHub {
    owner = "martabal";
    repo = "qbittorrent-exporter";
    rev = "v${version}";
    sha256 = "sha256-tQYD6jhFRojZst19gT44PlNKRcx9VzXyg4ZMJpqdzsE=";
  };

  vendorHash = "sha256-Zj59M+PXbMX71krbIelp9jZ0mpifFvfnpsPIJOeYyto=";

  meta = with lib; {
    description = "A fast and lightweight prometheus exporter for qBittorrent";
    homepage = "https://github.com/martabal/qbittorrent-exporter";
    license = licenses.mit;
    maintainers = [ ];
  };
}
