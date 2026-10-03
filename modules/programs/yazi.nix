# ==============================================================================
# МОДУЛЬ ПРОГРАММ: modules/programs/yazi.nix
# ==============================================================================
# Описание:
#   Yazi — современный консольный файловый менеджер на Rust с асинхронным
#   движком и нативным предпросмотром изображений, видео, PDF и архивов
#   прямо в терминале Ghostty через протокол Kitty Graphics.
#
# Горячие клавиши:
#   В Niri:    Mod + E -> Запуск Yazi в терминале Ghostty
#   В консоли: y       -> Запуск Yazi с переходом в выбранную папку при выходе
#   В Yazi:    h / j / k / l -> Навигация (влево, вниз, вверх, вправо)
#              Space         -> Выбор файла
#              Enter         -> Открыть файл
#              q             -> Выход
# ==============================================================================

{ config, pkgs, lib, ... }:

{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";

    # Настройки Yazi (yazi.toml)
    settings = {
      manager = {
        show_hidden = true;
        sort_by = "natural";
        sort_dir_first = true;
        linemode = "size";
      };

      preview = {
        tab_size = 2;
        max_width = 1000;
        max_height = 1000;
        image_quality = 85;
      };
    };
  };

  # Вспомогательные пакеты для генерации миниатюр и предпросмотра
  home.packages = with pkgs; [
    ffmpegthumbnailer # Генерация превью для видео
    poppler-utils     # Генерация превью для PDF (pdftoppm)
    unar              # Предпросмотр содержимого архивов
    file              # Определение MIME-типов файлов
  ];
}
