{
  hostname,
  arch,
  pkgs,
  ...
}:

{
  # Enable flake
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Automatic store optimization (deduplication)
  nix.optimise.automatic = true;

  # Timezone & Locale
  time.timeZone = "Asia/Ho_Chi_Minh";
  i18n.defaultLocale = "en_US.UTF-8";

  # Console font
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable sudo for wheel group
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;

  # Hostname
  networking.hostName = hostname;

  # Faster man page lookups
  documentation.man.generateCaches = true;

  # Common system packages (available to all users)
  environment.systemPackages = with pkgs; [
    vim
    jump
    neovim
    kitty
    tmux
    wget
    gcc
    gdb
    stow
    gnumake
    fzf
    ripgrep
    uv
    curl
    python3
    firefox
    unzip
    xdg-utils
    bat
    zoxide
    cmake
    zathura
    nix-index
    quickemu
    qemu
    ghostty
    ardour
  ];

  imports = [
    ./modules
  ];

  system.stateVersion = "25.05";
}
