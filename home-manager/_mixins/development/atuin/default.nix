{
  config,
  ...
}:
{
  age.secrets.atuin_key = {
    file = ../../../../secrets/atuin_key.age;
    path = "${config.home.homeDirectory}/.local/share/atuin/key";
  };

  programs = {
    atuin = {
      enable = true;
      enableFishIntegration = config.programs.fish.enable;
      flags = [ "--disable-up-arrow" ];
      settings = {
        auto_sync = true;
        sync_frequency = "5m";
        update_check = false;
        sync.records = true;
        dotfiles.enabled = false;
      };
    };
  };
}
