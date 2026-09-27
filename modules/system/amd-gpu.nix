# ==============================================================================
# СИСТЕМНЫЙ МОДУЛЬ: modules/system/amd-gpu.nix
# ==============================================================================
# Описание:
#   Конфигурация открытых драйверов для видеокарт AMD (Mesa / RADV)
#   с полной поддержкой аппаратного ускорения видео (VA-API / VDPAU)
#   и Vulkan под Wayland.
#
# Как проверить работу ускорения в системе:
#   vainfo        # Проверка декодирования видео (должен показать radeonsi)
#   vulkaninfo    # Проверка поддержки Vulkan (RADV)
# ==============================================================================

{ config, pkgs, lib, ... }:

{
  # Загрузка модуля ядра amdgpu на самом раннем этапе (Early KMS)
  # Это гарантирует правильное разрешение экрана с первых секунд загрузки
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Указание системного драйвера для графической подсистемы
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Настройка графической подсистемы OpenGL / Vulkan
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Необходимо для 32-битных приложений (Steam, Wine и т.д.)

    extraPackages = with pkgs; [
      libva-utils          # Утилита vainfo для диагностики
      vaapiVdpau           # Прослойка VA-API -> VDPAU
      libvdpau-va-gl       # Драйвер VDPAU через OpenGL
      mesa.drivers         # Драйверы Mesa (RadeonSI, RADV)
      vulkan-loader        # Загрузчик Vulkan
      vulkan-tools         # Утилита vulkaninfo
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # Переменные окружения для принудительного использования аппаратного ускорения AMD
  environment.variables = {
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
  };
}
