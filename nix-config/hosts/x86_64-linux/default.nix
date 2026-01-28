{ pkgs, nixos-hardware, ... }:

{
  imports = [
    # Hardware-specific optimizations
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-gpu-amd
    nixos-hardware.nixosModules.common-pc-ssd

    # Local configs
    ./hardware-configuration.nix
    ./modules
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 2;  # Limit boot entries for small /boot
  boot.loader.efi.canTouchEfiVariables = true;

  # Use smaller busybox-based initrd instead of systemd (saves ~40MB per generation)
  boot.initrd.systemd.enable = false;
  boot.initrd.compressor = "zstd";
  boot.initrd.compressorArgs = [ "-19" ];  # Max compression for small /boot

  # Disable AMD GPU firmware in initrd (saves ~30MB, not needed for early boot)
  hardware.amdgpu.initrd.enable = false;

  # Enable network manager
  networking.networkmanager.enable = true;

  # Agenix secrets (temporarily disabled - need to rekey with host SSH key)
  # age.secrets.zerotier-network-id = {
  #   file = ../../secrets/zerotier-network-id.age;
  #   mode = "0400";
  # };

  # ZeroTier VPN (temporarily disabled)
  # services.zerotierone = {
  #   enable = true;
  #   joinNetworks = [ ];  # Networks are joined via secret file
  # };

  # Read ZeroTier network ID from secret and join (temporarily disabled)
  # systemd.services.zerotierone-join = {
  #   description = "Join ZeroTier network from secret";
  #   after = [ "zerotierone.service" ];
  #   wants = [ "zerotierone.service" ];
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     RemainAfterExit = true;
  #     ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.zerotierone}/bin/zerotier-cli join $(cat ${config.age.secrets.zerotier-network-id.path} | tr -d \"\\n\")'";
  #   };
  # };

  networking.firewall.allowedTCPPorts = [ 2377 7946 4789 ];
  networking.firewall.allowedUDPPorts = [ 2377 7946 4789 ];

  # Enable mongod
  services.mongodb = {
    enable = true;
    package = pkgs.mongodb-7_0;
    user = "mongodb";
    extraConfig = ''
      replication:
        replSetName: dbdiagramrs1
    '';
  };
  environment.systemPackages = with pkgs; [
    mongosh-bin
  ];

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  
  # USB
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  # Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };
}
