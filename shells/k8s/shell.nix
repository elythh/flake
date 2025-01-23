with import <nixpkgs> { config.allowUnfree = true; };
let
  pythonPackages = pkgs.python310Packages;
  inputs = [
    argo
    jq
    yq
    teleport
    terragrunt
    terraform
    vault-bin
    kubelogin

    kubectl

    azure-cli

    pythonPackages.python
    pythonPackages.venvShellHook
    pythonPackages.numpy
    pythonPackages.boto3
    pythonPackages.requests
    pythonPackages.magic
    go # needed for gojsonnet
  ];
in
pkgs.mkShell {
  name = "rfPythonEnv";
  venvDir = "./.venv";
  buildInputs = inputs;
  allowUnfree = true;

  # Run this command, only after creating the virtual environment
  postVenvCreation = ''
    unset SOURCE_DATE_EPOCH
    pip install -r requirements.txt
  '';
}
