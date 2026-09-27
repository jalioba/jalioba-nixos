# ==============================================================================
# МОДУЛЬ РАБОЧЕГО СТОЛА: modules/desktop/noctalia.nix
# ==============================================================================
# Описание:
#   Интеграция Noctalia Shell — современного графического окружения
#   для Wayland-композиторов (Niri, Hyprland, Sway) на базе Qt6/Quickshell.
#   Включает в себя верхний статусбар, быстрый лаунчер приложений,
#   центр уведомлений, OSD громкости и всплывающие меню.
#
# Как кастомизировать:
#   Конфигурация Noctalia хранится в ~/.config/noctalia/config.toml.
#   Вы можете менять положение бара (top/bottom), виджеты и горячие клавиши.
# ==============================================================================

{ config, pkgs, inputs, lib, ... }:

let
  # Получение пакета Noctalia из Flake-входа или системного nixpkgs
  noctaliaPkg = if (inputs ? noctalia && inputs.noctalia ? packages)
    then (inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default or pkgs.noctalia-shell)
    else pkgs.noctalia-shell;
in
{
  # Установка пакета Noctalia Shell
  home.packages = [
    noctaliaPkg
  ];

  # Конфигурация Noctalia Shell в формате TOML (~/.config/noctalia/config.toml)
  xdg.configFile."noctalia/config.toml".text = ''
    # ==============================================================================
    # ОСНОВНЫЕ НАСТРОЙКИ NOCTALIA SHELL
    # ==============================================================================

    [general]
    theme = "dark"
    font = "JetBrainsMono Nerd Font"
    font_size = 11

    # Панель задач / верхний статусбар
    [bar]
    position = "top"
    height = 36
    margin = 8
    padding = 6
    spacing = 8
    border_radius = 10
    background = "#1e1e2e" # Catppuccin Mocha base

    # Виджеты слева направо
    left = ["workspaces", "window_title"]
    center = ["clock"]
    right = ["network", "volume", "battery", "tray", "power"]

    # Виджет воркспейсов Niri
    [bar.workspaces]
    show_empty = false
    icon_active = "●"
    icon_inactive = "○"

    # Виджет часов
    [bar.clock]
    format = "%a %d %b  %H:%M"

    # Виджет громкости
    [bar.volume]
    show_percentage = true

    # Лаунчер приложений (App Launcher)
    [launcher]
    width = 540
    height = 420
    border_radius = 12
    show_icons = true
    placeholder = "Поиск приложений..."

    # Центр уведомлений
    [notifications]
    position = "top_right"
    timeout = 5000
    max_visible = 5
    border_radius = 10
  '';
}
