{ pkgs, ... }:
{
  # raw storage
  fileSystems."/mnt/parity-1t" = {
    device = "/dev/disk/by-id/usb-JMicron_Tech_DD56419883893-0:0-part1";
    fsType = "xfs";
    options = [
      "defaults"
      "noatime"
    ];
  };

  fileSystems."/mnt/storage-1t-1" = {
    device = "/dev/disk/by-id/usb-WD_My_Passport_25E3_575845314536363450455850-0:0-part1";
    fsType = "xfs";
    options = [
      "defaults"
      "noatime"
    ];
  };

  # mergerfs
  environment.systemPackages = with pkgs; [
    mergerfs
  ];

  fileSystems."/mnt/storage" = {
    device = "/mnt/storage-1t-1";
    fsType = "mergerfs";
    options = [
      "defaults"
      "allow_other"
      "use_ino"
      "cache.files=partial"
      "dropcacheonclose=true"
      "category.create=mfs"
    ];
  };

  # snapraid
  services.snapraid = {
    enable = true;

    parityFiles = [
      "/mnt/parity-1t/snapraid.parity"
    ];

    contentFiles = [
      "/mnt/parity-1t/.snapraid.content"
      "/mnt/storage-1t-1/.snapraid.content"
    ];

    dataDisks = {
      d1 = "/mnt/storage-1t-1/";
    };

    sync.interval = "02:00";
    scrub.interval = "Mon *-*-* 06:00:00";
  };
}
