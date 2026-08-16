{ pkgs, lib, ... }:
let
  src = pkgs.fetchFromGitHub {
    owner = "sbondCo";
    repo = "Watcharr";
    rev = "v4.2.1";
    hash = "sha256-PGKRQW0/+7GZJaDyGDVRvLVirxUTmbbPdDbIkVcZcQo=";
  };

  ui = pkgs.buildNpmPackage {
    pname = "watcharr-ui";
    version = "4.2.1";
    inherit src;
    nodejs = pkgs.nodejs_24;
    npmDepsHash = "sha256-O0EctG2CYUtS+nI8ID5SerA3u2QavcYeuQ8cWSIvr40=";
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r build $out/
      runHook postInstall
    '';
  };
in
pkgs.buildGoModule {
  pname = "watcharr";
  version = "4.2.1";
  inherit src;
  modRoot = "server";
  subPackages = [ "." ];
  vendorHash = "sha256-lvTgwS/Pr83c17JIMjfgbWtH258PmhwqhMAXmZ6c48A=";
  env.CGO_ENABLED = 1;
  env.CGO_CFLAGS = "-D_LARGEFILE64_SOURCE";
  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ pkgs.sqlite ];
  preBuild = ''
    mkdir -p ui
    cp -r ${ui}/build/. ui/
  '';
  postInstall = ''
    mkdir -p "$out/ui"
    cp -r ${ui}/build/. "$out/ui/"
  '';
  meta = with lib; {
    description = "Self-hostable watched list (movies, TV, anime, games)";
    homepage = "https://watcharr.app";
    license = licenses.mit;
    platforms = platforms.all;
    mainProgram = "server";
  };
}
