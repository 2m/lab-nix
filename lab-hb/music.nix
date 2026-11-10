{ lib, ... }:
{
  options = {
    services.music-assistant.port = lib.mkOption {
      type = lib.types.int;
      description = "Port of the music-assistant service";
      default = 8095;
    };
  };

  config = {
    services.music-assistant = {
      enable = true;
      openFirewall = true;
      providers = [
        "ai_radio"
        "chromecast"
        "fastmcp_server"
        "filesystem_local"
        "genius_lyrics"
        "hass"
        "hass_players"
        "spotify"
        "spotify_connect"
      ];
    };
  };
}
