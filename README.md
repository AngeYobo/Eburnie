
# Eburnie

**Eburnie** is a customized Substrate-based blockchain designed to support decentralized applications for  financial infrastructure, such as mobile payments, and local identity systems.

---

## 🚀 Development Environment Setup (with Nix)

### 🛠 Prerequisites

- [Nix](https://nixos.org)
- [direnv](https://direnv.net)

### 📦 1. Install Nix

```bash
curl -L https://nixos.org/nix/install | sh
````

### ⚙️ 2. Install direnv

```bash
nix-env -iA nixpkgs.direnv
```

Then hook it into your shell:

```bash
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
# or for Zsh:
echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc
```

Restart your shell or run `source ~/.bashrc`.

---

## 📥 Clone the Repository

```bash
git clone https://github.com/eburnie/eburnie-node.git
cd eburnie-node
```

Enable direnv for the project:

```bash
direnv allow
```

---

## 🛠 Build and Run the Node

```bash
cargo build --release
./target/release/solochain-template-node --dev
```

This will launch a local development node with Alice/Bob accounts pre-funded.

---

### Persistent Chain State

To persist your local development chain data:

```bash
mkdir eburnie-chain-state
./target/release/solochain-template-node --dev --base-path ./eburnie-chain-state
```
This will create a directory `eburnie-chain-state` where your blockchain data will be stored.

## 🌐 Connect to Polkadot.js Apps

Use this WebSocket endpoint in [Polkadot.js UI](https://polkadot.js.org/apps):

```
ws://127.0.0.1:9944
```

Or expose the port (if running remotely) and use that URL instead.

---

## 📦 Offline Setup (Optional)

If you have limited internet access, you can configure the Eburnie binary cache:

```nix
substituters = https://eburnie-cache.cachix.org
trusted-public-keys = eburnie-cache.cachix.org-1:YOUR_PUBLIC_KEY
```

---

## 🔧 `shell.nix` Environment

We use a reproducible `shell.nix` to ensure all dependencies are in place:

```nix
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
      targets = [ "wasm32-unknown-unknown" ];
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
```

---

## 📄 License

MIT or Apache 2.0 — please specify your preferred license.

---

## ✨ Credits

* [Substrate DevHub](https://substrate.dev/)
* [Parity Technologies](https://www.parity.io/)
* Eburnie community & contributors ❤️

````

---

## 📤 How to Upload to GitHub

### 1. Replace your `README.md` locally:

```bash
nano README.md
# (Paste the improved version and save)
````

### 2. Commit and push:

```bash
git add README.md
git commit -m "Improve README with clean setup instructions"
git push origin main
```

---

