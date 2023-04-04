# krew2nix

TL/DR:

```nix
environment.systemPackages =
  [ kubectl.withKrewPlugins (plugins: [ plugins.node-shell ]) ];
```

## Examples

### devShell

```nix
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.krew2nix.url = "github:eigengrau/krew2nix";
  inputs.krew2nix.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, flake-utils, krew2nix, ... }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      kubectl = krew2nix.packages.${system}.kubectl;
    in {
      devShell = pkgs.mkShell {
        nativeBuildInputs = [ pkgs.bashInteractive ];
        buildInputs = [
          pkgs.k9s
          pkgs.kubernetes-helm
          (kubectl.withKrewPlugins (plugins: [
            plugins.node-shell
          ]))
        ];
      };
    });
}
```
Enter with `nix develop`.
