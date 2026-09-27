-- =============================================================================
-- МОДУЛЬ СОВМЕСТИМОСТИ С NIXOS: lua/plugins/nix-mason.lua
-- =============================================================================
-- Описание:
--   В NixOS отсутствует стандартный путь /lib64, поэтому бинарники, которые
--   Mason пытается скачать напрямую из интернета, часто падают с ошибками.
--   Этот плагин отключает авто-скачивание в Mason и настраивает lspconfig
--   на использование LSP-серверов, установленных через Nix (nil, lua_ls).
-- =============================================================================

return {
  -- Отключаем автоустановку внешних бинарников в Mason
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {},
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      automatic_installation = false,
    },
  },

  -- Настройка языковых серверов, установленных через Nix Store
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- LSP для языка Nix (nil)
        nil_ls = {
          settings = {
            ["nil"] = {
              formatting = {
                command = { "nixpkgs-fmt" },
              },
            },
          },
        },

        -- LSP для Lua (lua-language-server)
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
      },
    },
  },

  -- Установка темы оформления по умолчанию
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
