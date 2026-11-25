{ pkgs, ... }:

{
  # Window system (swayfx for blur, rounded corners, shadows)
  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
  };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  # Cursor theme (fixes disappearing cursor in some web apps)
  environment.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  environment.systemPackages = with pkgs; [
    # Cursor theme
    bibata-cursors

    # Sway core
    swaylock-effects
    swayidle
    swww
    wofi

    # System tray support (SNI/AppIndicator)
    libappindicator-gtk3

    # Streaming & recording
    (wrapOBS { plugins = [ obs-studio-plugins.wlrobs ]; })

    # Screenshot & recording
    grim
    slurp
    wl-clipboard
    wf-recorder
    libnotify

    # Widgets
    eww

    # System controls
    brightnessctl
    pavucontrol
    pwvucontrol
    blueman
    networkmanagerapplet

    # Bar & notifications
    waybar
    swaynotificationcenter
  ];

  # No need if enable wayland but just add it here
  services.libinput.enable = true;
}
