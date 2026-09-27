# NixOS: Niri + Noctalia Shell + Ghostty + LazyVim Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a clean, modular, fully-commented NixOS Flake configuration with Niri scrollable tiling compositor, Noctalia desktop shell, Ghostty terminal, Fish shell + Starship prompt, LazyVim, Firefox, Yazi TUI & Thunar GUI file managers, AMD GPU acceleration, ReGreet login screen, and essential CLI tools.

**Architecture:** A Flake-based NixOS setup where `flake.nix` orchestrates system packages (`configuration.nix`), hardware modules (`modules/system/`), and user environment via Home Manager (`home.nix`). All user-facing tools (Niri, Noctalia, Ghostty, LazyVim, Fish, Firefox, Yazi) are isolated in `modules/desktop/` and `modules/programs/` with detailed navigation comments.

**Tech Stack:** Nix Flakes, NixOS Unstable, Home Manager, Niri, Noctalia Shell (Qt6/Quickshell), Ghostty, Fish, Starship, Neovim (Lua / LazyVim), Firefox, Yazi, Thunar, ReGreet (GTK4), AMD Mesa/RADV/VA-API.

---

### Task 1: Flake & System Foundation (`flake.nix`, `configuration.nix`, `hardware-configuration.nix`)

**Files:**
- Create/Overwrite: `flake.nix`
- Create/Overwrite: `configuration.nix`
- Create/Overwrite: `hardware-configuration.nix`

- [x] **Step 1: Write `flake.nix` with inputs for nixpkgs-unstable, home-manager, and noctalia**
  - Defines `nixosConfigurations.nixos` for architecture `x86_64-linux`.
  - Passes `inputs` to modules via `specialArgs`.
  - Imports `configuration.nix` and `home-manager.nixosModules.home-manager`.

- [x] **Step 2: Write `hardware-configuration.nix` safe fallback placeholder**
  - Includes standard boot modules and filesystems fallback with clear instructions to replace with output of `nixos-generate-config`.

- [x] **Step 3: Write `configuration.nix` with system services, bootloader, users, fonts, and module imports**
  - Systemd-boot EFI bootloader.
  - User `jalioba` with groups `wheel`, `networkmanager`, `video`, `audio`, `input`.
  - Default shell set to `pkgs.fish`.
  - Nix experimental features (`flakes`, `nix-command`).
  - Fonts: `nerdfonts.jetbrains-mono`, `font-awesome`, `noto-fonts`.
  - Imports `modules/system/amd-gpu.nix`, `modules/system/greetd.nix`, `modules/system/sound.nix`.

- [x] **Step 4: Commit Task 1**
  ```bash
  git add flake.nix configuration.nix hardware-configuration.nix
  git commit -m "feat(system): add flake.nix, base configuration.nix, and hardware placeholder"
  ```

---

### Task 2: System Modules (`modules/system/`)

**Files:**
- Create: `modules/system/amd-gpu.nix`
- Create: `modules/system/greetd.nix`
- Create: `modules/system/sound.nix`

- [x] **Step 1: Implement `modules/system/amd-gpu.nix`**
  - Enables `hardware.graphics` (Mesa, RADV, 32-bit support).
  - Configures VA-API / VDPAU hardware acceleration packages (`libva-utils`, `vaapiVdpau`, `libvdpau-va-gl`).
  - Sets kernel module `amdgpu`.
  - Detailed Russian navigation comments explaining driver switches.

- [x] **Step 2: Implement `modules/system/greetd.nix` with ReGreet (GTK4)**
  - Configures `programs.regreet` with `JetBrainsMono Nerd Font`, dark theme preference, and default command `niri-session`.
  - Provides hooks and paths for custom background wallpaper (`/etc/nixos/wallpaper.jpg` or `assets/wallpaper.jpg`).
  - Enables `services.greetd`.

- [x] **Step 3: Implement `modules/system/sound.nix` with PipeWire**
  - Enables `services.pipewire` with ALSA, PulseAudio, JACK emulation and WirePlumber.
  - Enables real-time privileges for audio (`security.rtkit.enable = true`).

- [x] **Step 4: Commit Task 2**
  ```bash
  git add modules/system/
  git commit -m "feat(system): add amd-gpu, greetd regreet, and pipewire sound modules"
  ```

---

### Task 3: Desktop Environment (`modules/desktop/`)

**Files:**
- Create: `modules/desktop/niri.nix`
- Create: `modules/desktop/noctalia.nix`

- [x] **Step 1: Implement `modules/desktop/niri.nix`**
  - Configures Niri via Home Manager `xdg.configFile."niri/config.kdl"`.
  - Binds:
    - `Mod+Return` -> `ghostty`
    - `Mod+B` -> `firefox`
    - `Mod+Space` -> `noctalia-shell ipc call launcher toggle`
    - `Mod+E` -> `ghostty -e yazi`
    - `Mod+Shift+F` -> `thunar`
    - `Mod+Q` -> close-window
    - `Mod+H/L` -> focus column left/right
    - `Mod+J/K` -> focus window down/up
    - `Mod+Shift+H/L` -> move column left/right
    - `Mod+R` -> switch preset column widths
    - Audio volume and brightness keys via `wpctl`
  - Autostart entries for `noctalia`, `polkit-gnome`, and wayland environment.
  - Window rules for Noctalia bars/popups and floating file pickers.

- [x] **Step 2: Implement `modules/desktop/noctalia.nix`**
  - Integrates `inputs.noctalia` package or Home Manager module.
  - Sets up statusbar with workspaces, clock, volume, battery, system tray.
  - Configures launcher and notification center settings.

- [x] **Step 3: Commit Task 3**
  ```bash
  git add modules/desktop/
  git commit -m "feat(desktop): add niri compositor config and noctalia shell module"
  ```

---

### Task 4: Shell, Prompt & CLI Tools (`modules/programs/fish.nix`, `starship.nix`, `cli.nix`)

**Files:**
- Create: `modules/programs/fish.nix`
- Create: `modules/programs/starship.nix`
- Create: `modules/programs/cli.nix`

- [x] **Step 1: Implement `modules/programs/fish.nix`**
  - Enables `programs.fish`.
  - Integrates shell aliases (`ls -> eza`, `cat -> bat`, `cd -> z`, `nix-rebuild`).
  - Enables `programs.zoxide.enable = true` and `programs.fzf.enable = true`.
  - Fastfetch greeting.

- [x] **Step 2: Implement `modules/programs/starship.nix`**
  - Enables `programs.starship`.
  - Custom prompt configuration: directory, git status/branch, nix-shell, command duration, error symbol.

- [x] **Step 3: Implement `modules/programs/cli.nix`**
  - Installs and configures: `git`, `htop`, `btop`, `ripgrep`, `fd`, `bat`, `eza`, `fzf`, `zoxide`, `jq`, `unzip`, `fastfetch`, `pciutils`.

- [x] **Step 4: Commit Task 4**
  ```bash
  git add modules/programs/fish.nix modules/programs/starship.nix modules/programs/cli.nix
  git commit -m "feat(programs): add fish shell, starship prompt, and cli utilities"
  ```

---

### Task 5: Terminal, Browser & File Managers (`modules/programs/ghostty.nix`, `firefox.nix`, `thunar.nix`, `yazi.nix`)

**Files:**
- Create: `modules/programs/ghostty.nix`
- Create: `modules/programs/firefox.nix`
- Create: `modules/programs/thunar.nix`
- Create: `modules/programs/yazi.nix`

- [x] **Step 1: Implement `modules/programs/ghostty.nix`**
  - Configures Ghostty with `catppuccin-mocha` theme, `JetBrainsMono Nerd Font`, 0.95 opacity, 10px padding, clipboard integration.

- [x] **Step 2: Implement `modules/programs/firefox.nix`**
  - Enables Firefox with Wayland flags (`MOZ_ENABLE_WAYLAND=1`), VA-API hardware acceleration, privacy defaults.

- [x] **Step 3: Implement `modules/programs/thunar.nix`**
  - Enables Thunar file manager, `xfce.thunar-archive-plugin`, `xfce.thunar-volman`, and thumbnails.

- [x] **Step 4: Implement `modules/programs/yazi.nix`**
  - Enables `programs.yazi` with shell integration (`y` command to cd on exit), image preview support in Ghostty via `ffmpegthumbnailer`, `poppler`, `unar`.

- [x] **Step 5: Commit Task 5**
  ```bash
  git add modules/programs/ghostty.nix modules/programs/firefox.nix modules/programs/thunar.nix modules/programs/yazi.nix
  git commit -m "feat(programs): add ghostty terminal, firefox, thunar, and yazi file managers"
  ```

---

### Task 6: Neovim + LazyVim Setup (`modules/programs/nvim/`)

**Files:**
- Create: `modules/programs/nvim/default.nix`
- Create: `modules/programs/nvim/config/init.lua`
- Create: `modules/programs/nvim/config/lua/config/lazy.lua`
- Create: `modules/programs/nvim/config/lua/config/options.lua`
- Create: `modules/programs/nvim/config/lua/config/keymaps.lua`
- Create: `modules/programs/nvim/config/lua/plugins/nix-mason.lua`

- [x] **Step 1: Implement `modules/programs/nvim/default.nix`**
  - Packages: `neovim`, `gcc`, `gnumake`, `ripgrep`, `fd`, `unzip`, `tree-sitter`, `nodejs`, `python3`, `nil`, `nixpkgs-fmt`, `lua-language-server`.
  - Links `config/` directory into `~/.config/nvim/` via `xdg.configFile."nvim"`.

- [x] **Step 2: Implement LazyVim Lua configuration**
  - `init.lua`: bootstraps `lazy.nvim` from GitHub if not already present.
  - `lua/config/lazy.lua`: configures LazyVim spec and defaults.
  - `lua/config/options.lua` & `keymaps.lua`: essential settings (line numbers, tabwidth, clipboard, leader = Space).
  - `lua/plugins/nix-mason.lua`: disables Mason automatic download/install to keep pure Nix stability.

- [x] **Step 3: Commit Task 6**
  ```bash
  git add modules/programs/nvim/
  git commit -m "feat(nvim): add neovim and lazyvim hybrid nixos configuration"
  ```

---

### Task 7: Home Manager Integration & Documentation (`home.nix`, `README.md`)

**Files:**
- Create/Overwrite: `home.nix`
- Create: `README.md`

- [x] **Step 1: Implement `home.nix`**
  - Imports all user modules (`desktop/niri.nix`, `desktop/noctalia.nix`, and all `modules/programs/*.nix`).
  - Sets `home.username = "jalioba"`, `home.homeDirectory = "/home/jalioba"`, `home.stateVersion = "24.11"`.
  - Enables `programs.home-manager.enable = true`.

- [x] **Step 2: Create comprehensive `README.md` in Russian**
  - Quick-start guide: cloning repo, generating `hardware-configuration.nix`, running `sudo nixos-rebuild switch --flake .#nixos`.
  - Keybindings cheat sheet for Niri, Ghostty, Yazi, Noctalia.
  - Explanations of how to customize themes, fonts, wallpapers, and add new packages.

- [x] **Step 3: Commit Task 7**
  ```bash
  git add home.nix README.md
  git commit -m "feat: complete home.nix imports and add comprehensive README"
  ```

---

### Task 8: Validation & Verification

- [x] **Step 1: Check syntax and flake structure**
  - Verify all Nix files parse without syntax errors.
  - Verify directory structure matches the spec.
- [x] **Step 2: Final Git status and commit if needed**
