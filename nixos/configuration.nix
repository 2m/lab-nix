{ pkgs, lib, config, ... }: {
  imports = [ ./gandicloud.nix ];

  environment.systemPackages = with pkgs; [ neovim htop tailscale ];

  networking.firewall = {
    enable = true;

    # always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];

    # allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [ config.services.tailscale.port ];

    # let you SSH in over the public internet
    allowedTCPPorts = [ 22 ];
  };

  services.caddy = {
    enable = true;
    virtualHosts."http://irc.2m.lt".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.thelounge.port}
    '';
  };

  services = {
    tailscale.enable = true;
    thelounge.enable = true;
  };
}
