{ lib, config, pkgs, ... }:

let
  cfg = config.profiles.services.jupyter;

  myPython = pkgs.python3.withPackages (ps: with ps; [
    ipykernel
    notebook
    jupyterlab
    numpy
    pandas
    matplotlib
    seaborn
    scikit-learn
    statsmodels
    tqdm
  ]);
in
{
  options.profiles.services.jupyter = {
    enable = lib.mkEnableOption "JupyterLab service with Python kernel";
  };

  config = lib.mkIf cfg.enable {
    services.jupyter = {
      enable      = true;
      command     = "jupyter-lab";
      user        = "habe";
      group       = "users";
      ip          = "0.0.0.0";
      port        = 8888;
      notebookDir = "/home/habe/notebooks";
      password    = "argon2:$argon2id$v=19$m=10240,t=10,p=8$3JV0zWyXjdqyBtSSMo/iPg$B7C24pNyHYe4whuXo5fwy9oA9jfAILMwzZo2+Gh34YY";

      extraEnvironmentVariables = {
        BROWSER_PATH = "${pkgs.google-chrome}/bin/google-chrome-stable";
      };

      kernels = {
        python3 = {
          displayName = "Python 3 (Nix)";
          language    = "python";
          argv = [
            "${myPython.interpreter}"
            "-m"
            "ipykernel_launcher"
            "-f"
            "{connection_file}"
          ];
        };
      };
    };
  };
}

