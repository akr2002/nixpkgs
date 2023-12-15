{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, dtc, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "cloud-hypervisor";
  version = "36.0";

  src = fetchFromGitHub {
    owner = "cloud-hypervisor";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-SgzohTW0tDn/O65rujZh7hsbvTeu4nQ0HvvXu9f92Vc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "acpi_tables-0.1.0" = "sha256-FYjzwCSjuTUDCCQPC2ccDpwRRaG1eT5XgV/b8uSu8uc=";
      "igvm-0.1.0" = "sha256-l+Qyhdy3b8h8hPLHg5M0os8aSkjM55hAP5nqi0AGmjo=";
      "kvm-bindings-0.6.0" = "sha256-wGdAuPwsgRIqx9dh0m+hC9A/Akz9qg9BM+p06Fi5ACM=";
      "kvm-ioctls-0.13.0" = "sha256-jHnFGwBWnAa2lRu4a5eRNy1Y26NX5MV8alJ86VR++QE=";
      "micro_http-0.1.0" = "sha256-wX35VsrO1vxQcGbOrP+yZm9vG0gcTZLe7gH7xuAa12w=";
      "mshv-bindings-0.1.1" = "sha256-vyNaKp89THzZ/UpfocEwaCUzCuQnBMyv/icuZEghZEQ=";
      "versionize_derive-0.1.4" = "sha256-oGuREJ5+FDs8ihmv99WmjIPpL2oPdOr4REk6+7cV/7o=";
      "vfio-bindings-0.4.0" = "sha256-hGhfOE9q9sf/tzPuaAHOca+JKCutcm1Myu1Tt9spaIQ=";
      "vfio_user-0.1.0" = "sha256-fAqvy3YTDKXQqtJR+R2nBCWIYe89zTwtbgvJfPLqs1Q=";
      "vm-fdt-0.2.0" = "sha256-lKW4ZUraHomSDyxgNlD5qTaBTZqM0Fwhhh/08yhrjyE=";
    };
  };

  separateDebugInfo = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optional stdenv.isAarch64 dtc;

  OPENSSL_NO_VENDOR = true;

  cargoTestFlags = [
    "--workspace"
    "--bins" "--lib" # Integration tests require root.
    "--exclude" "net_util" # /dev/net/tun
    "--exclude" "vmm"      # /dev/kvm
  ];

  meta = with lib; {
    homepage = "https://github.com/cloud-hypervisor/cloud-hypervisor";
    description = "Open source Virtual Machine Monitor (VMM) that runs on top of KVM";
    changelog = "https://github.com/cloud-hypervisor/cloud-hypervisor/releases/tag/v${version}";
    license = with licenses; [ asl20 bsd3 ];
    mainProgram = "cloud-hypervisor";
    maintainers = with maintainers; [ offline qyliss ];
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
