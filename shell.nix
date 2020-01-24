{ pkgs ? import <nixpkgs> {}
# , configs-src ? builtins.fetchGit {
#   url = "https://gitlab-int.galois.com/binary-analysis/nix";
#   ref = "master";
, configs-src ? ../fryingpan
, saw-script-config ? import (configs-src + "/saw-script/configs.nix") {
  abcBridge-src = ./galois/abcBridge;
  aig-src = ./galois/aig;
  binary-symbols-src = ./galois/flexdis86;
  cryptol-src = ./galois/cryptol;
  cryptol-verifier-src = ./galois/cryptol-verifier;
  crucible-src = ./galois/crucible;
  crucible-llvm-src = ./galois/crucible;
  crucible-jvm-src = ./galois/crucible;
  crucible-saw-src = ./galois/crucible;
  crux-src = ./galois/crucible;
  elf-edit-src = ./galois/elf-edit;
  flexdis86-src = ./galois/flexdis86;
  galois-dwarf-src = ./galois/dwarf;
  jvm-parser-src = ./galois/jvm-parser;
  jvm-verifier-src = ./galois/jvm-verifier;
  llvm-pretty-src = ./galois/llvm-pretty;
  llvm-pretty-bc-parser-src = ./galois/llvm-pretty-bc-parser;
  macaw-base-src = ./galois/macaw;
  macaw-symbolic-src = ./galois/macaw;
  macaw-x86-src = ./galois/macaw;
  macaw-x86-symbolic-src = ./galois/macaw;
  parameterized-utils-src = ./galois/parameterized-utils;
  saw-core-src = ./galois/saw-core;
  saw-core-aig-src = ./galois/saw-core-aig;
  saw-core-sbv-src = ./galois/saw-core-sbv;
  saw-core-what4-src = ./galois/saw-core-what4;
  saw-script-src = ./galois/saw-script;
  what4-src = ./galois/crucible;
  what4-abc-src = ./galois/crucible;
}
}:
let
  myghc = pkgs.haskellPackages.ghcWithPackages (hspkgs: [
    saw-script-config.saw-script
  ]);
  galois-repl = pkgs.writeShellScriptBin "galois-repl" ''
    if [[ $# -eq 0 ]]; then echo "Usage: $0 PACKAGE"; exit 1; fi
    ghci "-igalois/$1/src" -ignore-package "$1"
  '';
  galois-hie-bios = pkgs.writeShellScriptBin "galois-hie-bios" ''
    if [[ $# -eq 0 ]]; then echo "Usage: $0 PACKAGE"; exit 1; fi
    printf "%s" "-igalois/$1/src
    -ignore-package $1
    "
  '';
in
pkgs.mkShell {
  inputsFrom = with pkgs; [
  ];
  buildInputs = with pkgs; [
    myghc
    llvm
    haskellPackages.c2hs
    haskellPackages.alex
    haskellPackages.happy

    galois-repl
    galois-hie-bios
  ];
}
