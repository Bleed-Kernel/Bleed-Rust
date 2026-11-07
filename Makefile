BLIBC_DIR  ?= $(if $(wildcard ../blibc/include/bleed),../blibc,external/blibc)
BLIBC_REPO  = https://github.com/Bleed-Kernel/blibc.git
SYSROOT     = $(BLIBC_DIR)/sysroot

.DEFAULT_GOAL := all

include rust.mk

.PHONY: all blibc toolchain clean

all: $(BLEED_RUST_LIB)/libc.a

blibc:
	@if [ ! -d "$(BLIBC_DIR)" ]; then git clone $(BLIBC_REPO) $(BLIBC_DIR); fi
	@$(MAKE) -C $(BLIBC_DIR) --no-print-directory

toolchain:
	@command -v $(CARGO) >/dev/null || { echo "rust isnt installed, see https://rustup.rs"; exit 1; }
	$(dir $(CARGO))rustup target add $(BLEED_RUST_TARGET)

clean:
	rm -rf bin build target
