# ==============================================================================
# СИСТЕМНЫЙ МОДУЛЬ: modules/system/sound.nix
# ==============================================================================
# Описание:
#   Современная звуковая подсистема на базе PipeWire и WirePlumber.
#   Обеспечивает профессиональное аудио с низкой задержкой и полную
#   совместимость с ALSA, PulseAudio и JACK приложениями.
#
# Полезные команды для терминала:
#   wpctl status                       # Показать список аудиоустройств и выходов
#   wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+   # Увеличить громкость на 5%
#   wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle  # Вкл/выкл звук
# ==============================================================================

{ config, pkgs, lib, ... }:

{
  # Отключаем устаревший звуковой сервер PulseAudio во избежание конфликтов
  services.pulseaudio.enable = false;

  # Включение RealtimeKit (rtkit) для приоритетной обработки звука без задержек и щелчков
  security.rtkit.enable = true;

  # Основная служба PipeWire
  services.pipewire = {
    enable = true;

    # Эмуляция ALSA для классических Linux-приложений
    alsa.enable = true;
    alsa.support32Bit = true; # Для 32-битных игр и Wine/Proton

    # Эмуляция сервера PulseAudio (требуется большинству настольных программ и браузеров)
    pulse.enable = true;

    # Эмуляция JACK (для музыкального софта и низких задержек)
    jack.enable = true;

    # WirePlumber: модульный диспетчер сессий и устройств PipeWire
    wireplumber.enable = true;
  };

  # Утилиты для управления звуком из командной строки и хоткеев
  environment.systemPackages = with pkgs; [
    wireplumber # Содержит команду wpctl
    pavucontrol # Графический микшер громкости PulseAudio/PipeWire
    alsa-utils  # Базовые утилиты ALSA (alsamixer, aplay)
  ];
}
