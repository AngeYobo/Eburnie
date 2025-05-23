# Eburnie


## Development Environment Setup with Nix

1. Install Nix: `curl -L https://nixos.org/nix/install | sh`
2. Install `direnv`: `nix-env -i direnv`
3. Hook `direnv` into your shell (e.g., for Bash):
   ```bash
   echo 'eval "$(direnv hook bash)"' >> ~/.bashrc

### Clone the repository and enter the directory

git clone https://github.com/eburnie/eburnie-node.git
cd eburnie-node

### Allow direnv to load the environment

direnv allow

### Build and run the node

cargo build --release
./target/release/solochain-template-node --dev


## Offline Setup

If you have limited internet access, configure the Eburnie binary cache:

substituters = https://eburnie-cache.cachix.org
trusted-public-keys = eburnie-cache.cachix.org-1:your-public-key    



---

### **Updated `shell.nix`**
Here’s the revised `shell.nix` incorporating the recommendations:
```nix
let
  rustOverlay = import (builtins.fetchTarball {
    url = "https://github.com/oxalica/rust-overlay/tarball/6b1cf12374361859242a562e1933a7930649131a";
    sha256 = "0kh8jp78s7d0q3pz0i5pmsbgnpvlp65iv5nl7ciih5mikz2b9f3k";
  });

  pkgs = import (builtins.fetchTarball {
    url = "https://releases.nixos.org/nixpkgs/nixpkgs-24.05/nixexprs.tar.xz";
    sha256 = "1lr1h35prqkd1m1b4191k0g0lzl1sw4jw1q8ds5a8xndayh0rjw";
  }) {
    system = "x86_64-linux";
    overlays = [ rustOverlay ];
  };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    (rust-bin.stable."1.87.0".default.override {
      extensions = [ "rust-src" ];
      targets = [ "wasm32v1-none" ]; # Correct target for Substrate
    })
    clang_14
    llvmPackages_14.libclang
    openssl
    pkg-config
    protobuf
    nodejs_20
    yarn
    curl
    git
    # kannel  # For USSD/SMS gateways
    gmp     # For ZKP libraries
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