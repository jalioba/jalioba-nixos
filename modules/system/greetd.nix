# ==============================================================================
# СИСТЕМНЫЙ МОДУЛЬ: modules/system/greetd.nix
# ==============================================================================
# Описание:
#   Графический экран входа в систему на базе Greetd и ReGreet (GTK4).
#   Позволяет выбрать сессию (по умолчанию Niri), ввести пароль,
#   поддерживает установку фоновых обоев, тем GTK и кастомных шрифтов.
#
# Как кастомизировать обои:
#   Положите ваше изображение по пути, указанному в `background.path`
#   (например: /etc/nixos/assets/wallpaper.jpg) и пересоберите систему.
# ==============================================================================

{ config, pkgs, lib, ... }:

{
  # Включение графического экрана приветствия ReGreet (GTK4)
  services.displayManager.regreet = {
    enable = true;

    # Основные настройки внешнего вида
    settings = {
      # Фоновые обои экрана входа
      background = {
        # Если файл не существует, ReGreet отобразит аккуратный тёмный фон
        path = "/etc/nixos/assets/wallpaper.jpg";
        fit = "Cover"; # Варианты: "Cover", "Contain", "Fill", "ScaleDown"
      };

      # Оформление GTK
      GTK = {
        application_prefer_dark_theme = lib.mkDefault true;
        font_name = lib.mkForce "JetBrainsMono Nerd Font 11";
        theme_name = lib.mkDefault "Adwaita-dark";
        icon_theme_name = lib.mkDefault "Adwaita";
      };
    };
  };

  # Дополнительные настройки службы greetd
  services.greetd = {
    enable = true;
  };
}
