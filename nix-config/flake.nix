{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, agenix, disko }:
    let
      lib = nixpkgs.lib;
      hosts = [ "x86_64-linux" ];
      hostname = "hell";
      default-username = "huydna";
      other-pkgs = { };
    in
    {
      # NixOS configurations
      nixosConfigurations = lib.foldl
        (res: arch:
          lib.recursiveUpdate res {
            ${arch} = nixpkgs.lib.nixosSystem {
              system = arch;
              specialArgs = {
                inherit arch hostname default-username other-pkgs;
                inherit nixos-hardware agenix;
                inputs = { inherit self nixpkgs home-manager nixos-hardware agenix disko; };
              };
              modules = [
                # Configure nixpkgs
                {
                  nixpkgs.overlays = (import ./overlays);
                  nixpkgs.config.allowUnfree = true;
                }

                # Agenix module
                agenix.nixosModules.default

                # Home Manager module
                home-manager.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.backupFileExtension = "backup";
                  home-manager.extraSpecialArgs = {
                    inherit default-username;
                  };
                  home-manager.users.${default-username} = import ./home/${default-username};
                }

                # Host configuration
                ./hosts
              ];
            };
          })
        { }
        hosts;

      # Formatter for `nix fmt`
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      # Checks for CI
      checks.x86_64-linux = {
        build = self.nixosConfigurations.x86_64-linux.config.system.build.toplevel;
      };
    };
}