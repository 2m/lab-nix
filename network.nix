{
  config,
  ...
}:

{
  services = {
    tailscale.enable = true;
    openssh.enable = true;

    # publish and resolve *.local addresses
    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
        workstation = true;
      };
    };
  };

  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFdOC8PgQg6ZZG51pdVRFoihpD9a9D3e4gQKmDB/JVmh carla-31-03-2023"
  ];

  networking = {
    hostName = "lab-hb";
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "8.8.8.8" ];

    firewall = {
      enable = true;

      # always allow traffic from your Tailscale network
      trustedInterfaces = [ "tailscale0" ];

      # allow the Tailscale UDP port through the firewall
      allowedUDPPorts = [ config.services.tailscale.port ];

      # let you SSH in over the public internet
      allowedTCPPorts = [ 22 ];
    };
  };
}
