{ buildEnv
, callPackage
, kubectl
, lib
, makeWrapper
, runCommand
}:

let krewPlugins = callPackage ./krew-plugins.nix { };
in
kubectl.overrideAttrs (_: {
  passthru.withKrewPlugins = selectPlugins:
    let
      selectedPlugins = selectPlugins krewPlugins;
      kubectlWrapper = runCommand "kubectl-with-plugins-wrapper"
        {
          nativeBuildInputs = [ makeWrapper ];
          meta.priority = kubectl.meta.priority or 0 + 1;
        } ''
        makeWrapper ${kubectl}/bin/kubectl $out/bin/kubectl \
          --prefix PATH : ${lib.makeBinPath selectedPlugins}
      '';
    in
    buildEnv {
      name = "${kubectl.name}-with-plugins";
      paths = [ kubectlWrapper kubectl ];
    };
})
