# ==============================================================================
# МОДУЛЬ ПРОГРАММ: modules/programs/fish.nix
# ==============================================================================
# Описание:
#   Командная оболочка Fish: современный шелл с подсветкой синтаксиса,
#   умным автодополнением по клавише Tab, историей поиска и набором
#   полезных псевдонимов (алиасов).
#
# Полезные алиасы:
#   ls / ll / la    -> Просмотр файлов с иконками через eza
#   cat             -> Просмотр с подсветкой синтаксиса через bat
#   z <каталог>     -> Мгновенный переход по истории каталогов (zoxide)
#   y               -> Запуск Yazi с переходом в выбранную папку при выходе
#   nix-rebuild     -> Применение изменений текущей конфигурации
#   nix-clean       -> Очистка старых поколений и мусора Nix Store
# ==============================================================================

{ config, pkgs, lib, ... }:

{
  # Включение Fish в Home Manager
  programs.fish = {
    enable = true;

    # Пользовательские алиасы
    shellAliases = {
      # Замена стандартных утилит на современные аналоги
      ls = "eza --icons";
      ll = "eza -la --icons --git";
      la = "eza -a --icons";
      tree = "eza --tree --icons";
      cat = "bat --paging=never";
      grep = "rg";

      # Быстрые команды управления NixOS
      nix-rebuild = "sudo nixos-rebuild switch --flake .#nixos";
      nix-test = "sudo nixos-rebuild test --flake .#nixos";
      nix-clean = "sudo nix-collect-garbage -d && nix-collect-garbage -d && sudo nix-store --optimise";

      # Git сокращения
      g = "git";
      gst = "git status";
      gdiff = "git diff";
      glog = "git log --oneline --graph --decorate";
    };

    # Инициализация интерактивной сессии Fish
    interactiveShellInit = ''
      # Отключаем стандартное текстовое приветствие Fish
      set -g fish_greeting ""

      # Вызов сводки о системе fastfetch при открытии терминала (если установлен)
      if type -q fastfetch
          fastfetch
      end
    '';

    # Функции Fish
    functions = {
      # Обертка над yazi: при нажатии 'q' выходит с переходом в текущую открытую директорию
      y = ''
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
      '';
    };
  };

  # Интеграция умной навигации zoxide (команда 'z' вместо 'cd')
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # Интеграция интерактивного fuzzy-поиска fzf (Ctrl + R для истории, Ctrl + T для файлов)
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };
}
