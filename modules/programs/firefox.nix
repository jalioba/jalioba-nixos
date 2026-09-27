# ==============================================================================
# МОДУЛЬ ПРОГРАММ: modules/programs/firefox.nix
# ==============================================================================
# Описание:
#   Веб-браузер Mozilla Firefox с нативной поддержкой Wayland,
#   аппаратным ускорением воспроизведения видео через AMD VA-API
#   и улучшенными настройками приватности.
#
# Как проверить аппаратное ускорение в браузере:
#   Откройте в Firefox страницу: about:support
#   В разделе "Graphics" поле "Compositing" должно быть "WebRender",
#   а "Hardwared Video Decoding" — "supported".
# ==============================================================================

{ config, pkgs, lib, ... }:

{
  programs.firefox = {
    enable = true;

    # Пользовательский профиль
    profiles.jalioba = {
      isDefault = true;

      # Настройки Firefox (about:config)
      settings = {
        # Аппаратное ускорение видео через VA-API под Wayland
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
        "gfx.webrender.all" = true;

        # Использовать системные XDG Desktop диалоги открытия/сохранения файлов
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "widget.use-xdg-desktop-portal.mime-handler" = 1;

        # Отключение телеметрии и сбора данных Mozilla
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "experiments.supported" = false;
        "experiments.enabled" = false;

        # Отключение встроенных рекомендаций Pocket и спонсорских ссылок
        "extensions.pocket.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

        # Тёмная тема оформления контента по умолчанию
        "layout.css.prefers-color-scheme.content-override" = 0;
      };
    };
  };

  # Принудительный запуск Firefox нативно под Wayland без XWayland
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };
}
