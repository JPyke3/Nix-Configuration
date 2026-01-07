# PLACEHOLDER: This file will be regenerated during NixOS installation
# Run: nixos-generate-config --show-hardware-config
# Then replace this file with the generated output
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = ["amdgpu"];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  # Root filesystem (ext4)
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/bd0f0387-2f43-46fa-941f-1760d1df8b4f";
    fsType = "ext4";
    options = ["defaults" "noatime" "commit=60"];
  };

  # Boot partition
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/41A8-A5DF";
    fsType = "vfat";
    options = ["defaults" "umask=0077"];
  };

  # Home partition (btrfs) - keeping existing /home
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/b4e2d88e-4499-401c-b9df-0cd6dbe103a3";
    fsType = "btrfs";
    options = ["defaults" "noatime" "compress=zstd" "space_cache=v2" "commit=120"];
  };

  # zram swap (configured via systemd)
  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  # Hardware configuration
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
