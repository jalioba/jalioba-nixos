# ==============================================================================
# СИСТЕМНЫЙ МОДУЛЬ: modules/system/sddm.nix
# ==============================================================================
# Описание:
#   Графический экран входа в систему на базе SDDM (Simple Desktop Display Manager)
#   с темой оформления Astronaut (профиль hyprland_kath):
#   - Репозиторий: https://github.com/Keyitdev/sddm-astronaut-theme
#   - Нативная работа под Wayland
#   - Анимированный фон и эффекты размытия (Qt6 + QtMultimedia)
#   - Сессия по умолчанию: Niri
# ==============================================================================

{ config, pkgs, lib, ... }:

let
  # Пакет темы Astronaut с предустановленным конфигом hyprland_kath
  sddm-astronaut-theme = pkgs.sddm-astronaut.override {
    embeddedTheme = "hyprland_kath";
  };
in
{
  services.displayManager = {
    # Сессия по умолчанию при входе
    defaultSession = "niri";

    sddm = {
      enable = true;
      wayland.enable = true; # Нативный запуск SDDM в Wayland
      package = pkgs.kdePackages.sddm; # Современный SDDM на базе Qt6
      theme = "sddm-astronaut-theme";

      # Дополнительные Qt6-компоненты для работы векторных иконок и видеофона
      extraPackages = [
        sddm-astronaut-theme
        pkgs.kdePackages.qtsvg
        pkgs.kdePackages.qtmultimedia
        pkgs.kdePackages.qtvirtualkeyboard
      ];
    };
  };

  # Добавляем тему в системные пакеты
  environment.systemPackages = [
    sddm-astronaut-theme
  ];
}
