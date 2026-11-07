RUST_DIR ?= $(if $(wildcard ../Bleed-Rust/rust.mk),../Bleed-Rust,external/Bleed-Rust)
CARGO    ?= $(firstword $(wildcard $(HOME)/.cargo/bin/cargo) cargo)
RUSTC    ?= $(firstword $(wildcard $(HOME)/.cargo/bin/rustc) rustc)

BLEED_RUST_TARGET = x86_64-unknown-linux-musl
BLEED_RUST_LIB    = $(abspath $(RUST_DIR))/build/lib
BLEED_RUSTFLAGS   = -C link-self-contained=no -C relocation-model=static -C target-feature=+crt-static

BLEED_CARGO = BLEED_SYSROOT=$(abspath $(SYSROOT)) BLEED_RUST_LIB=$(BLEED_RUST_LIB) \
	CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_LINKER=$(abspath $(RUST_DIR))/bleed/bleed-cc \
	CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_RUSTFLAGS="$(BLEED_RUSTFLAGS)" \
	$(CARGO) --config 'build.target="$(BLEED_RUST_TARGET)"'

$(BLEED_RUST_LIB)/libc.a: $(SYSROOT)/lib/blibc.a
	@mkdir -p $(BLEED_RUST_LIB)
	ln -sf $(abspath $(SYSROOT))/lib/blibc.a $(BLEED_RUST_LIB)/libc.a
	ln -sf $$($(RUSTC) --print sysroot)/lib/rustlib/$(BLEED_RUST_TARGET)/lib/self-contained/libunwind.a $(BLEED_RUST_LIB)/libunwind.a
