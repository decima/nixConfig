{ config, pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    slack
    kubectl
    kubectx
    kubelogin
    kubernetes-helm
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    azure-cli
    postgresql_14

    asdf-vm
    python312Full
    python312Packages.uv
    python312Packages.venvShellHook
    python312Packages.psycopg2

    fzf
    jetbrains.pycharm-community

    golangci-lint
  ];

  programs.nix-ld.enable = true;

}
