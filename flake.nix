{
  description = "An example of cabal usage with buildinfo file";
  inputs.nixpkgs.url = "nixpkgs";
  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" ];
      forAllSystems =
        f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      });
    in
    {
      overlay = (final: prev: {
        cabal-buildinfo-example =
          final.haskellPackages.callCabal2nix "cabal-buildinfo-example" ./. { };
      });
      packages = forAllSystems (system: {
        cabal-buildinfo-example = nixpkgsFor.${system}.cabal-buildinfo-example;
      });
      defaultPackage =
        forAllSystems (system: self.packages.${system}.cabal-buildinfo-example);
      checks = self.packages;
      devShell = forAllSystems (system:
        let haskellPackages = nixpkgsFor.${system}.haskellPackages;
        in haskellPackages.shellFor {
          packages = p: [ self.packages.${system}.cabal-buildinfo-example ];
          withHoogle = false;
          buildInputs = with haskellPackages; [ cabal-install ];
        });
    };
    # Change the prompt to show that you are in a devshell
    nixConfig.bash-prompt = ''\n\[\e[1;32m\][devshell:\w]\$\[\e[0m\] '';
}
