{
  description = "Development environment";

  inputs = {
      nixpkgs = { url = "github:NixOS/nixpkgs/nixpkgs-unstable"; };
      flake-utils = { url = "github:numtide/flake-utils"; };
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (nixpkgs.lib) optional;
        pkgs = import nixpkgs {
          inherit system;
        };

        nodeDependencies = (pkgs.callPackage ./default.nix {}).nodeDependencies;
      in
      {
          devShell = pkgs.mkShell
          {
            buildInputs =
              (with pkgs; [
                nodejs
                inotify-tools
                # needed for emacs to unzip elixir-ls
                unzip
                # used to manage js using nix
                node2nix
              ]);
            shellHook = ''
              if [ ! -d ./node_modules ]; then
                echo "Setting up node"
                ln -s ${nodeDependencies}/lib/node_modules ./node_modules
              fi
            '';
          };
      }
    );
}
