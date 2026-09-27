# ==============================================================================
# МОДУЛЬ ПРОГРАММ: modules/programs/starship.nix
# ==============================================================================
# Описание:
#   Starship — ультра-быстрый, настраиваемый кросс-шелл промпт.
#   Отображает текущую директорию, ветку и статус Git, индикатор окружения
#   Nix (nix-shell / flake), статус выполнения команд и время работы.
#
# Как кастомизировать:
#   Параметры внешнего вида задаются в блоке `settings`.
#   Вы можете менять иконки, цвета или формат строки ввода.
# ==============================================================================

{ config, pkgs, lib, ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      # Общий формат промпта (в 2 строки для максимального удобства и чистоты)
      format = "$directory$git_branch$git_status$nix_shell$cmd_duration$line_break$character";

      # Не вставлять пустую строку перед выводом
      add_newline = false;

      # Символ строки ввода
      character = {
        success_symbol = "[❯](bold #a6e3a1)"; # Зеленый цвет при успехе
        error_symbol = "[❯](bold #f38ba8)";   # Красный цвет при ошибке
      };

      # Отображение директории
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold #89b4fa"; # Светло-синий Catppuccin
        read_only = " 󰌾";
      };

      # Ветка Git
      git_branch = {
        symbol = " ";
        style = "bold #f9e2af"; # Желтый оттенок
        format = "на [$symbol$branch]($style) ";
      };

      # Статус Git (изменения, неотслеживаемые файлы)
      git_status = {
        style = "bold #f38ba8";
        format = "([$all_status$ahead_behind]($style) )";
        conflicted = "󰞇 ";
        ahead = "⇡\${count} ";
        behind = "⇣\${count} ";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count} ";
        untracked = "?\${count} ";
        modified = "!\${count} ";
        staged = "+\${count} ";
      };

      # Индикатор Nix Shell (flake devShell или nix-shell)
      nix_shell = {
        symbol = " ";
        style = "bold #74c7ec";
        format = "в [$symbol($name)]($style) ";
      };

      # Время выполнения команды (если дольше 2 секунд)
      cmd_duration = {
        min_time = 2000;
        style = "bold #fab387";
        format = "за [$duration]($style) ";
      };
    };
  };
}
