{ ... }:
{
  services.hister = {
    enable = true;
    port = 4433;
    settings = {
      server = {
        address = "127.0.0.1:4433";
        base_url = "https://hist.lab.2m.lt/";
      };
    };
  };
}
