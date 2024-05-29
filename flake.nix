{
  description = "A very basic flake";

  inputs = {
    nixpkgs.follows = "nix-ros/nixpkgs";
    nix-ros = {
      url = "github:lopsided98/nix-ros-overlay";
      inputs = {
        flake-utils.follows = "flake-utils";
      };
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nix-ros, flake-utils }:
    with nixpkgs.lib;
    with flake-utils.lib;
    eachSystem allSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
	  nix-ros.overlays.default
	  (self: super: {
	    # Comment out the override and it works
	    python3 = super.python3.override {
	      self = self.python3;
	    };
	  })
	];
      };
    in {
      devShells = {
        example = import ./example.nix { inherit pkgs; };
      };
  });

  nixConfig = {
    extra-substituters = [ "https://ros.cachix.org" ];
    extra-trusted-public-keys = [ "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo=" ];
  };
}
