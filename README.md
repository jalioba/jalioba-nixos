# Конфигурация NixOS: Niri + Noctalia Shell + Ghostty + LazyVim

Современная, быстрая, воспроизводимая и модульная конфигурация **NixOS** на базе **Nix Flakes** и **Home Manager** для пользователя `jalioba`.

---

## 🌟 Включенные компоненты

* **Оконный менеджер**: [Niri](https://github.com/YaLTeR/niri) — бесконечная горизонтальная лента скроллящегося тайлинга под Wayland.
* **Оболочка рабочего стола**: [Noctalia Shell](https://noctalia.dev) — современный верхний статусбар, лаунчер приложений, OSD и центр уведомлений на Qt6/Quickshell.
* **Экран входа (Display Manager)**: `greetd` + [ReGreet](https://github.com/rharish101/ReGreet) (GTK4) с поддержкой обоев, темной темы и шрифтов.
* **Терминал**: [Ghostty](https://ghostty.org) — сверхбыстрый GPU-ускоренный эмулятор терминала с темой Catppuccin Mocha.
* **Командная оболочка**: [Fish](https://fishshell.com) — умный шелл с автодополнением по Tab, интеграцией с `zoxide`, `fzf` и быстрыми алиасами.
* **Промпт**: [Starship](https://starship.rs) — информативная строка состояния с веткой Git, индикатором Nix Shell и временем выполнения.
* **Редактор кода**: [Neovim](https://neovim.io) + [LazyVim](https://www.lazyvim.org) — гибридная конфигурация: LSP (`nil`, `lua-ls`), компиляторы и утилиты управляются через Nix, а плагины LazyVim работают без конфликтов с путями NixOS.
* **Браузер**: [Firefox](https://www.mozilla.org/firefox/) — нативный Wayland, аппаратное декодирование видео AMD (VA-API), настройки приватности.
* **Файловые менеджеры**:
  * **TUI**: [Yazi](https://yazi-rs.github.io) — ультра-быстрый терминальный файловый менеджер с предпросмотром картинок/видео/PDF прямо в Ghostty (Kitty graphics protocol) и умной сменой каталога при выходе (`y`).
  * **GUI**: [Thunar](https://docs.xfce.org/xfce/thunar/start) — графический файловый менеджер с корзиной, плагинами для архивов и монтированием дисков (`gvfs`).
* **Графика и звук**: Открытые драйверы AMD (Mesa / RADV / VA-API) и звуковой сервер PipeWire + WirePlumber.
* **CLI-утилиты**: `git`, `htop`, `btop`, `ripgrep`, `fd`, `bat`, `eza`, `fzf`, `zoxide`, `fastfetch`.

---

## 📁 Структура проекта

```text
jalioba-nixos/
├── flake.nix                  # Входная точка Flake: inputs и системные хосты
├── configuration.nix          # Общесистемные настройки (ядро, пользователи, шрифты, сеть)
├── hardware-configuration.nix # Аппаратный профиль оборудования хоста
├── home.nix                   # Главный профиль пользователя jalioba (Home Manager)
└── modules/
    ├── system/                # Общесистемные модули
    │   ├── amd-gpu.nix        # Драйверы видеокарты AMD, Mesa, RADV, VA-API
    │   ├── greetd.nix         # Экран входа ReGreet (GTK4)
    │   └── sound.nix          # Звуковой сервер PipeWire и утилиты
    ├── desktop/               # Графическая среда
    │   ├── niri.nix           # Оконный менеджер Niri (разметка ленты, хоткеи)
    │   └── noctalia.nix       # Оболочка Noctalia Shell (бар, лаунчер)
    └── programs/              # Пользовательские программы
        ├── ghostty.nix        # Терминал Ghostty
        ├── fish.nix           # Оболочка Fish и алиасы
        ├── starship.nix       # Промпт Starship
        ├── firefox.nix        # Браузер Firefox
        ├── thunar.nix         # Графический менеджер файлов Thunar
        ├── yazi.nix           # Терминальный менеджер файлов Yazi
        ├── cli.nix            # Git, htop, btop, ripgrep, bat, eza
        └── nvim/              # Neovim + LazyVim
            ├── default.nix    # Пакет Neovim, компиляторы и LSP
            └── config/        # Стартовые Lua-файлы LazyVim
```

---

## 🚀 Быстрый старт

### 1. Клонирование репозитория
Склонируйте конфигурацию в каталог `/etc/nixos` или в вашу домашнюю папку:
```bash
git clone https://github.com/jalioba/jalioba-nixos ~/CODES/jalioba-nixos
cd ~/CODES/jalioba-nixos
```

### 2. Привязка аппаратной конфигурации (Hardware)
Сгенерируйте спецификацию вашего реального железа (диски, процессор, контроллеры):
```bash
# Скопируйте существующий файл оборудования:
cp /etc/nixos/hardware-configuration.nix ./hardware-configuration.nix
# Либо сгенерируйте заново:
nixos-generate-config --show-hardware-config > hardware-configuration.nix
```

### 3. Добавление файлов в Git (Обязательно для Nix Flakes!)
Nix Flakes читает **только** те файлы, которые отслеживаются Git:
```bash
git add .
```

### 4. Применение конфигурации
```bash
sudo nixos-rebuild switch --flake .#nixos
```

После завершения перезагрузите компьютер:
```bash
reboot
```

---

## ⌨️ Основные горячие клавиши

Клавиша-модификатор: **`Mod` = `Super` (клавиша Windows)**.

| Комбинация | Действие |
| :--- | :--- |
| `Mod + Enter` | Запустить терминал **Ghostty** |
| `Mod + B` | Запустить браузер **Firefox** |
| `Mod + Space` | Открыть лаунчер приложений **Noctalia** |
| `Mod + E` | Открыть консольный менеджер файлов **Yazi** в Ghostty |
| `Mod + Shift + F` | Открыть графический менеджер файлов **Thunar** |
| `Mod + Q` | Закрыть активное окно |
| `Mod + H / L` или `Влево / Вправо` | Перемещение фокуса между колонками на ленте Niri |
| `Mod + J / K` или `Вниз / Вверх` | Перемещение фокуса внутри колонки |
| `Mod + Shift + H / L` | Переместить колонку влево/вправо по ленте |
| `Mod + Shift + J / K` | Переместить окно внутри колонки вниз/вверх |
| `Mod + R` | Переключить ширину колонки (33% → 50% → 66% → 100%) |
| `Mod + F` | Развернуть активную колонку на максимум |
| `Mod + Ctrl + F` | Полноэкранный режим для окна |
| `Mod + 1..5` | Переключение на рабочее пространство 1..5 |
| `Mod + Shift + 1..5` | Переместить окно на рабочее пространство 1..5 |
| `Mod + Shift + S` | Сделать скриншот выделенной области в буфер обмена |
| `Mod + Shift + E` | Завершить сессию Niri |
| `Alt + Shift` | Переключение раскладки клавиатуры (US ⟷ RU) |

---

## 🛠️ Полезные команды в терминале

* `nix-rebuild` — применить изменения конфигурации (`sudo nixos-rebuild switch --flake .#nixos`).
* `nix-test` — протестировать конфигурацию без записи в загрузчик.
* `nix-clean` — удалить старые поколения системы и освободить место на диске.
* `y` — запуск **Yazi**: при выходе по `q` вы автоматически перейдете в открытую в Yazi папку!
* `z <имя_папки>` — умный быстрый переход по каталогам через **zoxide** (вместо медленного `cd`).
* `ll` / `tree` — просмотр содержимого директорий с красивыми иконками через **eza**.
* `fastfetch` — отображение системной информации и характеристик ПК.

---

## 🎨 Кастомизация

1. **Обои для экрана входа (ReGreet)**:
   Поместите изображение в `/etc/nixos/assets/wallpaper.jpg` или укажите собственный путь в файле [modules/system/greetd.nix](file:///modules/system/greetd.nix).
2. **Панель и лаунчер Noctalia**:
   Настройки статус-бара, виджетов и лаунчера находятся в файле [modules/desktop/noctalia.nix](file:///modules/desktop/noctalia.nix).
3. **Терминал Ghostty**:
   Изменить тему, шрифт или прозрачность можно в [modules/programs/ghostty.nix](file:///modules/programs/ghostty.nix).
4. **Плагины Neovim / LazyVim**:
   Новые Lua-плагины для редактора можно добавлять в каталог [modules/programs/nvim/config/lua/plugins/](file:///modules/programs/nvim/config/lua/plugins/).
