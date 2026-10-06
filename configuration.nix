# ==============================================================================
# ОБЩЕСИСТЕМНАЯ КОНФИГУРАЦИЯ: configuration.nix
# ==============================================================================
# Описание:
#   Определяет базовые настройки операционной системы NixOS:
#   - Загрузчик (systemd-boot EFI)
#   - Сеть и сетевой менеджер
#   - Локализация (язык, часовой пояс, консоль)
#   - Системный пользователь jalioba и права доступа
#   - Системные шрифты и интеграция Wayland/Niri
#   - Системные модули (AMD GPU, ReGreet, PipeWire звук)
# ==============================================================================

{ config, pkgs, inputs, ... }:

{
  imports = [
    # Аппаратная спецификация хоста
    ./hardware-configuration.nix

    # Системные модули
    ./modules/system/amd-gpu.nix   # Драйверы видеокарты AMD (Mesa / RADV / VA-API)
    ./modules/system/bluetooth.nix # Беспроводная связь Bluetooth (BlueZ + Blueman)
    ./modules/system/sddm.nix      # Экран входа SDDM (Astronaut theme / hyprland_kath)
    ./modules/system/sound.nix     # Звуковой сервер PipeWire + WirePlumber
  ];

  # ----------------------------------------------------------------------------
  # 1. ЗАГРУЗЧИК (BOOTLOADER)
  # Отключаем systemd-boot во избежание переполнения раздела /boot
  boot.loader.systemd-boot.enable = false;

  # Включение и настройка GRUB с поддержкой UEFI
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev"; # Для EFI-систем обязательно "nodev"
    useOSProber = true; # Автоматический поиск других ОС (Windows)
    configurationLimit = 10; # Хранить до 10 последних поколений системы
  };

  # Тема оформления GRUB от vinceliuice (стиль "stylish")
  boot.loader.grub2-theme = {
    enable = true;
    theme = "stylish";
    icon = "color";
    screen = "1080p";
  };

  # Время ожидания выбора системы в секундах
  boot.loader.timeout = 30;

  boot.loader.efi.canTouchEfiVariables = true;

  # Свежее стабильное ядро Linux
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ----------------------------------------------------------------------------
  # 2. СЕТЬ И ИМЯ ХОСТА
  # ----------------------------------------------------------------------------
  networking.hostName = "nixos"; # Имя вашего компьютера
  networking.networkmanager.enable = true; # Управление проводными и Wi-Fi сетями

  # ----------------------------------------------------------------------------
  # 3. ЛОКАЛИЗАЦИЯ И ЧАСОВОЙ ПОЯС
  # ----------------------------------------------------------------------------
  time.timeZone = "Europe/Moscow"; # При необходимости измените на ваш часовой пояс

  i18n.defaultLocale = "ru_RU.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # Раскладка клавиатуры в виртуальной консоли TTY
  console.keyMap = "ruwin_alt_sh-UTF-8";

  # ----------------------------------------------------------------------------
  # 4. ПОЛЬЗОВАТЕЛИ И ШЕЛЛ
  # ----------------------------------------------------------------------------
  # Включаем командную оболочку Fish на системном уровне
  programs.fish.enable = true;

  users.users.jalioba = {
    isNormalUser = true;
    description = "jalioba";
    extraGroups = [
      "networkmanager" # Управление сетями
      "wheel"          # Доступ к sudo
      "video"          # Доступ к видеоустройствам
      "audio"          # Доступ к аудиоустройствам
      "input"          # Доступ к устройствам ввода
    ];
    shell = pkgs.fish; # Оболочка по умолчанию
  };

  # ----------------------------------------------------------------------------
  # 5. ГРАФИЧЕСКИЙ СТЕК И WAYLAND (NIRI)
  # ----------------------------------------------------------------------------
  # Активация Niri на уровне системы: настраивает PAM, сессионные файлы и polkit
  programs.niri.enable = true;

  # XDG Desktop Portals: необходимы для открытия файлов, шеринга экрана и диалогов
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config.common.default = [ "gtk" "gnome" ];
  };

  # Служба безопасности Polkit (аутентификация для графических приложений)
  security.polkit.enable = true;

  # Поддержка виртуальных файловых систем (корзина, съемные носители, Thunar)
  services.gvfs.enable = true;
  services.tumbler.enable = true; # Генерация превью/миниатюр для изображений

  # ----------------------------------------------------------------------------
  # 6. ШРИФТЫ
  # ----------------------------------------------------------------------------
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono # Иконки и терминальный шрифт
    font-awesome              # Иконки для интерфейсов
    noto-fonts                # Базовые шрифты Unicode
    noto-fonts-cjk-sans       # Азиатские иероглифы
    noto-fonts-color-emoji    # Цветные эмодзи
  ];

  # Поддержка Dconf и Xfconf для настроек тем GTK, Thunar и диалогов
  programs.dconf.enable = true;
  programs.xfconf.enable = true;

  # Графический файловый менеджер Thunar с поддержкой плагинов
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  # ----------------------------------------------------------------------------
  # 7. ОБЩЕСИСТЕМНЫЕ ПАКЕТЫ И OVERLAYS
  # ----------------------------------------------------------------------------
  # Подключение сторонних оверлеев из Flakes
  nixpkgs.overlays = [
    inputs.fastpotify.overlays.default
  ];

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    vim
    polkit_gnome  # Графический агент ввода пароля root
    libnotify     # Отправка уведомлений (notify-send)
    fastpotify    # Быстрый и легковесный клиент Spotify (Fastpotify)
  ];

  # ----------------------------------------------------------------------------
  # 8. ПАРАМЕТРЫ NIX И ВЕРСИЯ СИСТЕМЫ
  # ----------------------------------------------------------------------------
  nix.settings = {
    # Включение современных возможностей: flakes и новой CLI-утилиты nix
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true; # Автоматическое устранение дубликатов в nix store
  };

  # Разрешить установку несвободных пакетов (например, проприетарных драйверов/кодеков)
  nixpkgs.config.allowUnfree = true;

  # Версия NixOS релиза
  system.stateVersion = "24.11";
}
