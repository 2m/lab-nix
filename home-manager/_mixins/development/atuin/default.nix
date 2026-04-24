{
  config,
  ...
}:
{
  age.secrets.atuin_key.file = ../secrets/atuin_key.age;

  programs = {
    atuin = {
      enable = true;
      enableFishIntegration = config.programs.fish.enable;
      flags = [ "--disable-up-arrow" ];
      settings = {
        auto_sync = true;
        key_path = config.age.secrets.atuin_key.path;
        sync_frequency = "5m";
        update_check = false;
        sync.records = true;
        dotfiles.enabled = false;
      };
    };
  };
}
