# ==============================================================================
# ПРОФИЛЬ ПОЛЬЗОВАТЕЛЯ: home.nix
# ==============================================================================
# Описание:
#   Главный конфигурационный файл Home Manager для пользователя "jalioba".
#   Объединяет все пользовательские модули:
#   - Оконный менеджер Niri и оболочка Noctalia Shell
#   - Терминал Ghostty, шелл Fish и промпт Starship
#   - Текстовый редактор Neovim + LazyVim
#   - Браузер Firefox и файловые менеджеры (Yazi, Thunar)
#   - Набор CLI-утилит (Git, htop, btop, ripgrep и др.)
#   - Единая тёмная тема оформления (Catppuccin Mocha)
# ==============================================================================

{ config, pkgs, inputs, lib, ... }:

{
  # ----------------------------------------------------------------------------
  # 1. СВЕДЕНИЯ О ПОЛЬЗОВАТЕЛЕ
  # ----------------------------------------------------------------------------
  home.username = "jalioba";
  home.homeDirectory = "/home/jalioba";

  # ----------------------------------------------------------------------------
  # 2. ПОДКЛЮЧЕНИЕ МОДУЛЕЙ
  # ----------------------------------------------------------------------------
  imports = [
    # Графическое окружение
    ./modules/desktop/niri.nix      # Тайлинговый Wayland-композитор Niri
    ./modules/desktop/noctalia.nix  # Wayland-оболочка Noctalia Shell

    # Терминал, шелл и промпт
    ./modules/programs/ghostty.nix  # GPU-ускоренный терминал Ghostty
    ./modules/programs/fish.nix     # Оболочка Fish
    ./modules/programs/starship.nix # Промпт Starship

    # Редактор кода
    ./modules/programs/nvim         # Neovim + LazyVim

    # Браузер и файловые менеджеры
    ./modules/programs/firefox.nix  # Браузер Firefox с ускорением VA-API
    ./modules/programs/thunar.nix   # Графический менеджер файлов Thunar
    ./modules/programs/yazi.nix     # Консольный менеджер файлов Yazi

    # Набор консольных утилит
    ./modules/programs/cli.nix      # Git, htop, btop, bat, eza, ripgrep и др.
  ];

  # ----------------------------------------------------------------------------
  # 3. ЕДИНОЕ ОФОРМЛЕНИЕ ИНТЕРФЕЙСА (GTK И QT)
  # ----------------------------------------------------------------------------
  # Настройка темной темы GTK
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  # Интеграция тем оформления для приложений на Qt (Noctalia, VLC и т.д.)
  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };

  # ----------------------------------------------------------------------------
  # 4. СЛУЖЕБНЫЕ ПАРАМЕТРЫ HOME MANAGER
  # ----------------------------------------------------------------------------
  # Разрешить Home Manager управлять самим собой
  programs.home-manager.enable = true;

  # Версия релиза Home Manager
  home.stateVersion = "24.11";
}
