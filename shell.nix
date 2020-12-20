{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.tcl
    pkgs.tcllib

    # keep this line if you use bash
    pkgs.bashInteractive
  ];
}
