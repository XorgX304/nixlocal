{system ? builtins.currentSystem,
 pkgs ? import <nixpkgs> {},
 lib ? pkgs.lib
}:

let
  haskell  = pkgs.haskellPackages;
  ocamlP   = pkgs.mkOcamlPackages self.ocaml ocamlP;
  baseCall = lib.callPackageWith (pkgs // pkgs.lib);
  selfCall = lib.callPackageWith (pkgs // self);
  camlCall = lib.callPackageWith (pkgs // ocamlP // self);
  allCall = lib.callPackageWith (pkgs // ocamlP // haskell // self);
  self = rec {
    ocaml = baseCall ./ocaml.nix {libX11 = null; xproto = null; useX11 = false;};
    vil = baseCall ./vim-lite.nix {};
    vim = allCall ./vim.nix {};
    latex = baseCall ./latex.nix {};
    bap = camlCall ./bap.nix {};
    libbap = camlCall ./libbap.nix {};
    bap_rust = selfCall ./bap-rust.nix {};
    holmes = selfCall ./holmes.nix {};
    bil = camlCall ./bil.nix {};
    caml_bz2 = camlCall ./camlbz2.nix {};
    ocamlPackages = ocamlP;
    ocaml_curses = camlCall ./ocaml-curses.nix {};
    ofuzz = camlCall ./ofuzz.nix {};
    ocaml_libinput = camlCall ./input.nix {};
    symfuzz = camlCall ./symfuzz.nix {};
    aflSymfuzz = baseCall ./afl-symfuzz.nix {};
    xmonad = pkgs.xmonad-with-packages.override {
      packages = self: [self.xmonad-contrib self.xmonad-extras];
    };
  };
in
self
