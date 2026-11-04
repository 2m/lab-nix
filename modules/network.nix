{
  config,
  ...
}:

{
  services = {
    tailscale.enable = true;

    # publish and resolve *.local addresses
    avahi = {
      enable = true;
      nssmdns4 = true;
      settings.publish = {
        "disable-publishing" = false;
        "disable-user-service-publishing" = false;
        "publish-addresses" = true;
        "publish-domain" = true;
        "publish-hinfo" = true;
        "publish-workstation" = true;
      };
    };
  };

  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFdOC8PgQg6ZZG51pdVRFoihpD9a9D3e4gQKmDB/JVmh carla-31-03-2023"
  ];

  networking = {
    hostName = config.vars.hostname;
    networkmanager.enable = true;
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];

    firewall = {
      enable = true;

      # always allow traffic from your Tailscale network
      trustedInterfaces = [ "tailscale0" ];

      # allow the Tailscale UDP port through the firewall
      allowedUDPPorts = [ config.services.tailscale.port ];

      # let you SSH in over the public internet
      allowedTCPPorts = config.services.openssh.ports;
    };
  };
}
