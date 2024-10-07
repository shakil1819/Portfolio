# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-23.11"; # or "unstable"

  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.nodejs_20
    pkgs.nodePackages.http-server # Lightweight static web server
  ];

  # Sets environment variables in the workspace
  env = {
    PORT = "8080"; # Default port for the web server
  };

  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      # "vscodevim.vim"
    ];

    # Enable previews
    previews = {
      enable = true;
      previews = {
        web = {
          # Start the static web server on launch and use the specified port
          command = ["http-server" "." "-p" "$PORT"];
          manager = "web";
          env = {
            PORT = "$PORT"; # Use IDX defined port for previews
          };
        };
      };
    };

    # Workspace lifecycle hooks
    workspace = {
      # Runs when a workspace is first created
      onCreate = {
        # No npm install needed for basic HTML/CSS/JS
      };
      # Runs when the workspace is (re)started
      onStart = {
        # Start the lightweight static web server when the workspace starts
        start-web-server = "http-server . -p $PORT";
      };
    };
  };
}
