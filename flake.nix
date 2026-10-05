# ==============================================================================
# ТОЧКА ВХОДА СИСТЕМЫ: flake.nix
# ==============================================================================
# Описание:
#   Главный конфигурационный файл Nix Flake. Объявляет внешние зависимости
#   (репозитории nixpkgs, home-manager, noctalia shell) и определяет
#   целевую конфигурацию машины "nixos" для пользователя "jalioba".
#
# Как применить конфигурацию на машине:
#   sudo nixos-rebuild switch --flake .#nixos
# ==============================================================================

{
  description = "NixOS конфигурация jalioba: Niri + Noctalia Shell + Ghostty + LazyVim";

  inputs = {
    # Основной репозиторий пакетов NixOS (ветка unstable для самых свежих версий)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager для управления пользовательскими файлами и приложениями
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia Shell: современная Wayland-оболочка (бар, лаунчер, уведомления)
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Темы оформления GRUB от vinceliuice
    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Fastpotify: легковесный клиент Spotify
    fastpotify = {
      url = "github:gnkz/fastpotify.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      # Имя хоста совпадает с networking.hostName в configuration.nix
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        # Проброс внешних flakes в модули через аргумент `inputs`
        specialArgs = { inherit inputs; };

        modules = [
          # Модуль тем оформления GRUB
          inputs.grub2-themes.nixosModules.default

          # Общесистемная конфигурация
          ./configuration.nix

          # Интеграция Home Manager в общую систему NixOS
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };

            # Профиль пользователя jalioba
            home-manager.users.jalioba = import ./home.nix;
          }
        ];
      };
    };
  };
}
