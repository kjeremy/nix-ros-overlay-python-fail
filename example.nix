{ pkgs ? import ./. {} }:
with pkgs;
with rosPackages.noetic;

mkShell {
  nativeBuildInputs = [
    (buildEnv {
      paths = [
        ros-core
        #colcon
        #geometry-msgs
      ];
    })
  ];
}
