{ ... }:
{
  services.calibre-web = {
    enable = true;
    options = {
      enableBookUploading = true;
      calibreLibrary = "/var/lib/calibre-library";
    };
  };
}
