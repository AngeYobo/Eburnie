let
  rustOverlay = import (builtins.fetchTarball {
    url = "https://github.com/oxalica/rust-overlay/tarball/6b1cf12374361859242a562e1933a7930649131a";
    sha256 = "0kh8jp78s7d0q3pz0i5pmsbgnpvlp65iv5nl7ciih5mikz2b9f3k";
  });

  pkgs = import (builtins.fetchTarball {
    url = "https://releases.nixos.org/nixpkgs/nixpkgs-25.11pre801852.3fcbdcfc707e/nixexprs.tar.xz";
    sha256 = "1axizzdkrgzbd7wd3wjisafjnkgvyy8fhiv5zmp5zwi28n0jn0wi";
  }) {
    system = "x86_64-linux";
    overlays = [ rustOverlay ];
  };
in
pkgs.mkShell {
  
  buildInputs = with pkgs; [
    direnv
    (rust-bin.stable."1.87.0".default.override {
      extensions = [ "rust-src" ];
      targets = [ "wasm32v1-none" ];
    })
    clang_14
    llvmPackages_14.libclang
    openssl
    pkg-config
    protobuf
    cmake
    nodejs_20
    yarn
    curl
    git
    gmp
    zlib
    binaryen
    direnv
  ];

  shellHook = ''
    export LIBCLANG_PATH=${pkgs.llvmPackages_14.libclang.lib}/lib
    export PROTOC=${pkgs.protobuf}/bin/protoc
    export PATH=${pkgs.protobuf}/bin:$PATH
    export CC=clang
    export CXX=clang++
    export RUST_BACKTRACE=1
    export DIRENV_LOG_FORMAT=""
  '';
}

