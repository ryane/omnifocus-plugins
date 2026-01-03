{
  description = "OmniFocus plugins development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            just
          ];

          shellHook = ''
            echo "OmniFocus Plugins Development Environment"
            echo ""
            echo "Available commands:"
            echo "  just list        - Show all available plugins"
            echo "  just install     - Install a specific plugin"
            echo "  just install-all - Install all plugins"
            echo "  just show-dir    - Show OmniFocus plugins directory"
            echo "  just open-dir    - Open OmniFocus plugins directory"
            echo ""
          '';
        };
      }
    );
}
