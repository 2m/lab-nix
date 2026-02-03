{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "intel-gpu-exporter";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "clambin";
    repo = "intel-gpu-exporter";
    rev = "v${version}";
    sha256 = "sha256-BCFZMoTHzU7qwXUp4PRFUzo+u+h+cMKEUMAazPlhDyQ=";
  };

  vendorHash = "sha256-6zPDONdCp0X+ZCzAmBsBLeNPN4Rtm7IGpg7FttYbsxU=";

  patchPhase = ''
    patch -p0 < ${./intel-gpu-exporter-1.patch}
  '';

  meta = with lib; {
    description = "Exports GPU statistics for Intel Quick Sync Video GPU's ";
    homepage = "https://github.com/clambin/intel-gpu-exporter";
    license = licenses.mit;
    maintainers = [ ];
  };
}
