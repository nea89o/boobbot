{
  inputs = {
    #   dlang-nix.url = "github:PetarKirov/dlang-nix";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "x86_64-darwin" "aarch64-darwin"];
      perSystem = {
        inputs',
        pkgs,
        ...
      }: {
        packages = {
          boobbot = pkgs.buildDubPackage rec {
            pname = "boobbot";
            version = "0.0.0";
            src = ./.;
            dubLock = ./dub-lock.json;
            installPhase = ''
              runHook preInstall
              install -Dm755 boobbot -t $out/bin
							patchelf --set-rpath ${pkgs.lib.makeLibraryPath buildInputs} $out/bin/boobbot
              runHook postInstall
            '';
            buildInputs = [pkgs.openssl];
          };
        };
        formatter = pkgs.alejandra;
        devShells.default = pkgs.mkShell rec {
          buildInputs = [
            pkgs.openssl
          ];
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
          packages = [
            pkgs.ldc
            pkgs.dub
            pkgs.lldb
            pkgs.dub-to-nix
          ];
        };
      };
    };
}
