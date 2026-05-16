[
  (final: prev: {
    pnpm_11 = (prev.callPackage (prev.path + "/pkgs/development/tools/pnpm/generic.nix") {
      version = "11.0.0";
      hash = "sha256-ZFamQO4TmA9uBcISiKKi9qdISu7lU2WmXXqpMbvLbyE=";
    }).overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        chmod +x $out/libexec/pnpm/bin/pnpm.cjs $out/libexec/pnpm/bin/pnpx.cjs
      '';
    });

    mongosh-bin = prev.stdenv.mkDerivation rec {
      pname = "mongosh-bin";
      version = "2.2.6";

      src = prev.fetchurl {
        url = "https://github.com/mongodb-js/mongosh/releases/download/v${version}/mongosh-${version}-linux-x64.tgz";
        sha256 = "M2cCibhis3ciFT3Wmp/5FwcdPwJANqllEswM2XWdrRA=";
      };

      sourceRoot = ".";

      installPhase = ''
        tar -xzf ${src}
        mkdir -p $out/bin
        cp -r mongosh-2.2.6-linux-x64/bin/* $out/bin/
      '';

      meta = with prev.lib; {
        description = "MongoDB Shell (binary release)";
        homepage = "https://www.mongodb.com/products/shell";
        license = licenses.asl20;
        platforms = [ "x86_64-linux" ];
      };
    };
  })
]