BUILD := build
EDK2_OVMF := /usr/share/edk2-ovmf
OVMF := $(EDK2_OVMF)/x64/OVMF.4m.fd
OVMF_CODE := $(EDK2_OVMF)/x64/OVMF_CODE.4m.fd
OVMF_VARS := $(EDK2_OVMF)/x64/OVMF_VARS.4m.fd

all-rust: build-rust qemu-rust

build-rust:
	cargo build --target x86_64-unknown-uefi
	mkdir -p $(BUILD)/esp/EFI/BOOT
	cp target/x86_64-unknown-uefi/debug/NeroUEFI.efi $(BUILD)/esp/EFI/BOOT/BOOTX64.efi

qemu-rust: build-rust
	# Points to esp folder
	qemu-system-x86_64 -enable-kvm \
    -drive if=pflash,format=raw,readonly=on,file=$(OVMF_CODE) \
    -drive if=pflash,format=raw,readonly=on,file=$(OVMF_VARS) \
    -drive format=raw,file=fat:rw:$(BUILD)/esp

clean:
	cargo clean
	# -rf
	rm -r $(BUILD)/* || echo "Clean Rust"