{
  pkgs,
  ...
}:
{
  programs.fish.enable = true; # puts fish in /etc/shells

  users.defaultUserShell = pkgs.fish;

  services = {
    openssh = {
      enable = true;
      extraConfig = ''
        AllowAgentForwarding yes
      '';
    };
  };
}
