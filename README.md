# krew2nix

TL/DR:

```nix
environment.systemPackages =
  [ kubectl.withKrewPlugins (plugins: [ plugins.node-shell ]) ];
```
