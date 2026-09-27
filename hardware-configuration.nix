# ==============================================================================
# АППАРАТНАЯ КОНФИГУРАЦИЯ: hardware-configuration.nix
# ==============================================================================
# ВАЖНО:
#   Этот файл является безопасным шаблоном/заглушкой. При установке на реальное
#   железо или виртуальную машину скопируйте сюда содержимое файла:
#       /etc/nixos/hardware-configuration.nix
#   или выполните команду:
#       nixos-generate-config --show-hardware-config > hardware-configuration.nix
# ==============================================================================

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Модули ядра для загрузки накопителей и контроллеров
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # Корневой раздел (замените на ваш UUID из реального hardware-configuration.nix)
  fileSystems."/" = {
    device = lib.mkDefault "/dev/disk/by-label/nixos";
    fsType = lib.mkDefault "ext4";
  };

  # Раздел EFI (замените на ваш раздел /boot или /boot/efi)
  fileSystems."/boot" = {
    device = lib.mkDefault "/dev/disk/by-label/boot";
    fsType = lib.mkDefault "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  # Swap-раздел (если используется)
  swapDevices = [ ];

  # Архитектура хоста
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
