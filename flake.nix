{
  description = "A very basic flake";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

  outputs = {
    self,
    nixpkgs,
  }: {
    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
    packages.x86_64-linux.book = with nixpkgs.legacyPackages.x86_64-linux;
      stdenvNoCC.mkDerivation {
        name = "book";
        src = ./doc;

        nativeBuildInputs = [quarto];

        dontConfigure = true;

        buildPhase = ''
          runHook preBuild

          export HOME=$PWD
          quarto render

          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall

          cp -r _site/ "$out"

          runHook postInstall
        '';
      };

    checks.x86_64-linux.all-packages = self.packages.x86_64-linux.hello;

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
