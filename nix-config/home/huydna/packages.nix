{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Development runtimes & languages
    nodejs_22
    bun
    deno
    ruby
    rustup
    go
    erlang_27
    php
    racket

    # Build tools & compilers
    clang
    clang-tools
    jdk

    # Package managers
    yarn
    pnpm

    # Databases
    postgresql_16
    mysql84

    # Web servers
    apacheHttpd

    # Language servers & dev tools
    lua-language-server
    jdt-language-server
    marksman
    nodePackages_latest.eslint
    oxlint
    biome
    typescript
    ruff
    texlab
    tinymist
    typstyle

    # VS Code extensions
    vscode-extensions.vue.volar
    vscode-extensions.vue.vscode-typescript-vue-plugin

    # Document tools
    typst
    ## obsidian

    # Communication
    vesktop # Discord client with better Wayland/tray support
    slack
    spotify

    # Media
    ## melonDS

    # CLI tools
    lazygit
    tree
    jq
    ffmpeg

    # Security
    _1password-gui

    # AI tools
    claude-code

    # Nix development
    nil # Nix LSP
    nixfmt-rfc-style # Nix formatter (matches flake formatter)
  ];
}
