# ==============================================================================
# МОДУЛЬ РАБОЧЕГО СТОЛА: modules/desktop/niri.nix
# ==============================================================================
# Описание:
#   Конфигурация Niri — бесконечного скроллящегося тайлингового Wayland-
#   композитора. Описывает раскладку окон, клавиатурные сокращения,
#   автозапуск Noctalia Shell и правила отображения окон.
#
# Основные горячие клавиши (Mod = Win/Super):
#   Mod + Enter      -> Терминал Ghostty
#   Mod + B          -> Браузер Firefox
#   Mod + Space      -> Лаунчер приложений Noctalia
#   Mod + E          -> Терминальный файловый менеджер Yazi
#   Mod + Shift + F  -> Графический файловый менеджер Thunar
#   Mod + Q          -> Закрыть активное окно
#   Mod + H/L        -> Навигация между колонками (влево/вправо)
#   Mod + J/K        -> Навигация внутри колонки (вниз/вверх)
#   Mod + R          -> Переключить ширину колонки (33%, 50%, 66%, 100%)
#   Mod + F          -> Максимизировать колонку
# ==============================================================================

{ config, pkgs, lib, ... }:

{
  # Необходимые вспомогательные утилиты для работы под Niri/Wayland
  home.packages = with pkgs; [
    brightnessctl # Управление яркостью дисплея
    grim          # Снятие скриншотов под Wayland
    slurp         # Выделение области экрана
    wl-clipboard  # Работа с буфером обмена (wl-copy, wl-paste)
    libnotify     # Всплывающие уведомления
  ];

  # Генерация конфигурационного файла ~/.config/niri/config.kdl
  xdg.configFile."niri/config.kdl".text = ''
    // =============================================================================
    // УСТРОЙСТВА ВВОДА (КЛАВИАТУРА И ТАЧПАД)
    // =============================================================================
    input {
        keyboard {
            xkb {
                // Английская и русская раскладки
                layout "us,ru"
                // Переключение раскладок по комбинации Alt + Shift
                options "grp:alt_shift_toggle,caps:escape"
            }
            repeat-delay 250
            repeat-rate 35
        }

        touchpad {
            tap
            natural-scroll
            dwt // Отключать тачпад во время набора текста (disable-while-typing)
            accel-speed 0.2
        }
    }

    // =============================================================================
    // НАСТРОЙКИ ВЫВОДА (МОНИТОРЫ)
    // =============================================================================
    output "eDP-1" {
        // Режим по умолчанию для встроенных экранов ноутбуков
        mode "1920x1080@60.000"
        scale 1.0
    }

    // =============================================================================
    // РАЗМЕТКА ОКОН И ЛЕНТЫ (LAYOUT)
    // =============================================================================
    layout {
        gaps 12
        center-focused-column "never"

        default-column-width { proportion 0.5; }

        // Пресеты ширины колонок при нажатии Mod + R
        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
            proportion 1.0
        }

        // Обводка активного окна (акцент Catppuccin Mocha)
        focus-ring {
            width 2
            active-color "#cba6f7"
            inactive-color "#313244"
        }

        // Тени окон
        shadow {
            on
            softness 30
            spread 5
            offset x=0 y=5
            color "#11111b80"
        }
    }

    // =============================================================================
    // АВТОЗАПУСК ПРИ ВХОДЕ В СЕССИЮ
    // =============================================================================
    spawn-at-startup "systemctl" "--user" "import-environment" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP"
    spawn-at-startup "dbus-update-activation-environment" "--systemd" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP"

    // Запуск графического агента Polkit для запросов паролей
    spawn-at-startup "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"

    // Запуск оболочки Noctalia Shell (статусбар, лаунчер, центр уведомлений)
    spawn-at-startup "noctalia"

    // =============================================================================
    // ГОРЯЧИЕ КЛАВИШИ (BINDS)
    // =============================================================================
    binds {
        // --- Запуск основных приложений ---
        Mod+Return { spawn "ghostty"; }
        Mod+B      { spawn "firefox"; }
        Mod+Space  { spawn "noctalia" "msg" "panel-toggle" "launcher"; }
        Mod+E      { spawn "ghostty" "-e" "yazi"; }
        Mod+Shift+F { spawn "thunar"; }

        // --- Управление окнами ---
        Mod+Q { close-window; }

        // Навигация по ленте окон (стрелками или hjkl)
        Mod+Left  { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+H     { focus-column-left; }
        Mod+L     { focus-column-right; }

        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }
        Mod+J     { focus-window-down; }
        Mod+K     { focus-window-up; }

        // Перемещение колонок и окон внутри ленты
        Mod+Shift+Left  { move-column-left; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+H     { move-column-left; }
        Mod+Shift+L     { move-column-right; }

        Mod+Shift+Down  { move-window-down; }
        Mod+Shift+Up    { move-window-up; }
        Mod+Shift+J     { move-window-down; }
        Mod+Shift+K     { move-window-up; }

        // Быстрый переход в начало/конец ленты
        Mod+Home { focus-column-first; }
        Mod+End  { focus-column-last; }

        // Управление размером колонок
        Mod+R          { switch-preset-column-width; }
        Mod+F          { maximize-column; }
        Mod+Ctrl+F     { fullscreen-window; }
        Mod+Minus      { set-column-width "-10%"; }
        Mod+Equal      { set-column-width "+10%"; }

        // --- Виртуальные рабочие пространства (Workspaces) ---
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }

        Mod+Shift+1 { move-window-to-workspace 1; }
        Mod+Shift+2 { move-window-to-workspace 2; }
        Mod+Shift+3 { move-window-to-workspace 3; }
        Mod+Shift+4 { move-window-to-workspace 4; }
        Mod+Shift+5 { move-window-to-workspace 5; }

        // --- Скриншоты (область в буфер обмена) ---
        Mod+Shift+S { spawn "sh" "-c" "grim -g \"$(slurp)\" - | wl-copy"; }

        // --- Мультимедиа клавиши (управление громкостью через PipeWire/wpctl) ---
        XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }

        // --- Управление яркостью экрана ---
        XF86MonBrightnessUp   allow-when-locked=true { spawn "brightnessctl" "set" "+5%"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "set" "5%-"; }

        // --- Завершение сессии ---
        Mod+Shift+E { quit; }
    }

    // =============================================================================
    // ПРАВИЛА ОТОБРАЖЕНИЯ ОКОН (WINDOW RULES)
    // =============================================================================
    // Плавающие окна для системных диалогов, выбора файлов и микшера
    window-rule {
        match app-id=r#"^(pavucontrol|polkit-gnome-authentication-agent-1)$"#
        open-floating true
    }
  '';
}
