# Спецификация конфигурации NixOS: Niri + Noctalia Shell + Ghostty + LazyVim

## 1. Общие сведения и цели
Создание модульной, декларативной и воспроизводимой конфигурации NixOS на базе Nix Flakes и Home Manager для пользователя `jalioba` на хосте `nixos`.

### Ключевые компоненты:
* **База**: NixOS (ветка `nixos-unstable`), Nix Flakes.
* **Пользователь**: `jalioba`, системный хостнейм: `nixos`.
* **Оконный менеджер (Wayland Compositor)**: `Niri` (скроллящийся тайлинг).
* **Оболочка рабочего стола**: `Noctalia Shell` (статусбар, виджеты, лаунчер, центр уведомлений).
* **Экран входа (Display Manager)**: `greetd` + графический `ReGreet` (GTK4) с поддержкой обоев и шрифтов.
* **Графика и аппаратное ускорение**: AMD GPU (Mesa, RADV, VA-API аппаратное декодирование).
* **Звук**: PipeWire + WirePlumber + эмуляция ALSA/PulseAudio/JACK.
* **Терминал**: `Ghostty` (GPU-ускоренный, тема Catppuccin Mocha, JetBrainsMono Nerd Font).
* **Шелл**: `Fish` с настроенными алиасами и плагинами.
* **Промпт**: `Starship` (информативный, быстрый, с интеграцией git и nix-shell).
* **Редактор**: `Neovim` + `LazyVim` (гибридная модель: Lua-конфиги под управлением Home Manager, отключенный конфликтный Mason, LSP и компиляторы под управлением Nix).
* **Браузер**: `Firefox` (Wayland native, аппаратное ускорение VA-API, приватные настройки).
* **CLI-утилиты**: `git`, `htop`, `btop`, `ripgrep`, `fd`, `bat`, `eza`, `fzf`, `zoxide`, `jq`, `unzip`, `fastfetch`.

---

## 2. Архитектура и структура каталогов

```text
jalioba-nixos/
├── flake.nix                  # Точка входа: Flake inputs и NixOS конфигурация
├── configuration.nix          # Общесистемные параметры (ядро, загрузчик, юзер jalioba, сеть, службы)
├── hardware-configuration.nix # Аппаратная спецификация оборудования (с защитой от отсутствия)
├── home.nix                   # Главный модуль Home Manager для пользователя jalioba
└── modules/
    ├── system/
    │   ├── amd-gpu.nix        # Драйверы Mesa, RADV, VA-API
    │   ├── greetd.nix         # Экран входа ReGreet (GTK4)
    │   └── sound.nix          # PipeWire + WirePlumber
    ├── desktop/
    │   ├── niri.nix           # Niri: разметка ленты, хоткеи, автозапуск Noctalia, правила окон
    │   └── noctalia.nix       # Noctalia Shell: статусбар, лаунчер, уведомления
    └── programs/
        ├── fish.nix           # Командная оболочка Fish и интеграции
        ├── ghostty.nix        # Эмулятор терминала Ghostty
        ├── starship.nix       # Промпт Starship
        ├── firefox.nix        # Браузер Firefox под Wayland
        ├── cli.nix            # Набор утилит (git, ripgrep, eza, fzf, btop и др.)
        └── nvim/
            ├── default.nix    # Neovim, компиляторы и LSP-пакеты (nil, lua-ls)
            └── config/        # Стартовые Lua-файлы LazyVim
                ├── init.lua
                ├── lua/
                │   ├── config/
                │   │   ├── lazy.lua
                │   │   ├── options.lua
                │   │   └── keymaps.lua
                │   └── plugins/
                │       └── nix-mason.lua
```

---

## 3. Детализация компонентов

### 3.1. Системный уровень (`configuration.nix` & `modules/system/`)
* **Bootloader**: `systemd-boot` с поддержкой EFI.
* **Сеть**: `networking.networkmanager.enable = true`, `networking.hostName = "nixos"`.
* **Пользователь**: `users.users.jalioba` с правами `wheel`, `networkmanager`, `video`, `audio`, дефолтный шелл — `pkgs.fish`.
* **AMD GPU**:
  * `hardware.graphics.enable = true`
  * `hardware.graphics.enable32Bit = true`
  * Драйверы: `amdgpu` для ядра, `mesa` для графики, `libva-utils` для VA-API.
* **Звук**:
  * `services.pipewire = { enable = true; alsa.enable = true; alsa.support32Bit = true; pulse.enable = true; };`
* **Экран входа ReGreet**:
  * `programs.regreet.enable = true`
  * Сессия запуска по умолчанию: `niri-session`.
  * Настройка темной темы GTK и шрифта `JetBrainsMono Nerd Font`.
* **Шрифты**:
  * `fonts.packages = [ nerdfonts.jetbrains-mono font-awesome noto-fonts noto-fonts-cjk-sans noto-fonts-emoji ]`.

### 3.2. Графическая среда Niri и Noctalia (`modules/desktop/`)
* **Niri**:
  * Включение `programs.niri.enable = true` на уровне системы.
  * Файл конфигурации `config.kdl` создается через Home Manager.
  * Основные биндинги:
    * `Mod+Return` -> `ghostty`
    * `Mod+B` -> `firefox`
    * `Mod+Space` -> запуск лаунчера Noctalia
    * `Mod+Q` -> `close-window`
    * `Mod+H / L` -> переключение между колонками
    * `Mod+J / K` -> переключение окон в колонке
    * `Mod+Shift+H / L` -> перемещение колонок
    * `Mod+R` -> переключение ширины колонок (33%, 50%, 66%, 100%)
    * `Mod+Shift+E` -> диалог выхода
    * Мультимедиа-клавиши: управление громкостью через `wpctl`
  * Автозапуск:
    * `spawn-at-startup "noctalia"`
    * `spawn-at-startup "${pkgs.polkit-gnome}/libexec/polkit-gnome-authentication-agent-1"`
* **Noctalia Shell**:
  * Подключение Flake input `inputs.noctalia.url = "github:noctalia-dev/noctalia"`.
  * Пакет `noctalia` и конфиг статусбара, центра уведомлений и лаунчера.

### 3.3. Пользовательские программы (`modules/programs/`)
* **Ghostty**:
  * Тема: `catppuccin-mocha`.
  * Шрифт: `JetBrainsMono Nerd Font`, размер 12.
  * Прозрачность: 0.95.
  * Паддинги: 10px по краям.
* **Fish**:
  * Интеграция со `starship`, `zoxide`, `fzf`.
  * Алиасы для `eza`, `bat`, `fastfetch` и быстрой пересборки системы (`nix-rebuild`).
* **Starship**:
  * Кастомный пресет: отображение каталога, git-статуса, индикатора flake/nix-shell.
* **Firefox**:
  * Переменная окружения `MOZ_ENABLE_WAYLAND = "1"`.
  * Поддержка VA-API для плавного воспроизведения медиа.
* **Neovim & LazyVim**:
  * Декларативная установка компиляторов и инструментов: `gcc`, `gnumake`, `ripgrep`, `fd`, `unzip`, `tree-sitter`, `nodejs`, `python3`, `nil`, `lua-language-server`.
  * Автоматический bootstrap `lazy.nvim` в `init.lua`.
  * Конфигурация в `plugins/nix-mason.lua` отключает автоматическую установку внешних бинарников Mason, чтобы не ломать систему NixOS.

---

## 4. Навигация и документация
Каждый файл конфигурации будет снабжен структурированными комментариями на русском языке:
* Назначение файла.
* Зависимости и связанные модули.
* Подсказки по кастомизации (например, как изменить тему, горячие клавиши или добавить новый LSP).
