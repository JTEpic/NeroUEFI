SRC := src
BUILD := build
USER_LIB := /usr/lib
GNU_EFI_INC := /usr/include/efi
# May change after update, currently here
GNU_EFI_LIB := /usr/lib
EDK2_OVMF := /usr/share/edk2-ovmf

MAIN_FILE := main
QEMU_TARGET := uefi.img

all:
	mkdir -p $(BUILD)

	gcc $(SRC)/$(MAIN_FILE).c           \
		-c                              \
		-fno-stack-protector            \
		-fpic                           \
		-fshort-wchar                   \
		-mno-red-zone                  	\
		-I $(GNU_EFI_INC)        		\
		-I $(GNU_EFI_INC)/x86_64 		\
		-DEFI_FUNCTION_WRAPPER          \
		-o $(BUILD)/$(MAIN_FILE).o
	#gcc -Ignu-efi-dir/inc -fpic -ffreestanding -fno-stack-protector -fno-stack-check -fshort-wchar -mno-red-zone -maccumulate-outgoing-args -c main.c -o main.o

	ld $(BUILD)/$(MAIN_FILE).o              	\
    	$(GNU_EFI_LIB)/crt0-efi-x86_64.o  		\
		-nostdlib                      			\
		-znocombreloc                  			\
		-T $(GNU_EFI_LIB)/elf_x86_64_efi.lds 	\
		-shared                        			\
		-Bsymbolic                     			\
		-L $(USER_LIB)               			\
		-l:libgnuefi.a                 			\
		-l:libefi.a                    			\
		-o $(BUILD)/$(MAIN_FILE).so
	#ld -shared -Bsymbolic -Lgnu-efi-dir/x86_64/lib -Lgnu-efi-dir/x86_64/gnuefi -Tgnu-efi-dir/gnuefi/elf_x86_64_efi.lds gnu-efi-dir/x86_64/gnuefi/crt0-efi-x86_64.o main.o -o main.so -lgnuefi -lefi

	objcopy -j .text                \
		-j .sdata               	\
		-j .data                	\
		-j .rodata					\
		-j .dynamic             	\
		-j .dynsym              	\
		-j .rel                 	\
		-j .rela                	\
		-j .reloc               	\
		--output-target=efi-app-x86_64 	\
		--subsystem=10				\
		$(BUILD)/$(MAIN_FILE).so   	\
		$(BUILD)/$(MAIN_FILE).efi
	#objcopy -j .text -j .sdata -j .data -j .rodata -j .dynamic -j .dynsym  -j .rel -j .rela -j .rel.* -j .rela.* -j .reloc --target efi-app-x86_64 --subsystem=10 main.so main.efi

	# Empty Img
	dd if=/dev/zero of=$(BUILD)/uefi.img bs=512 count=93750

	# Primary/Secondary GPT headers, plus EFI Partition
	parted $(BUILD)/uefi.img -s -a minimal mklabel gpt
	parted $(BUILD)/uefi.img -s -a minimal mkpart EFI FAT16 2048s 93716s
	parted $(BUILD)/uefi.img -s -a minimal toggle 1 boot

	# Temp Img to contain EFI Partition Data and FAT16, FAT32 is best though
	dd if=/dev/zero of=$(BUILD)/part.img bs=512 count=91669
	mformat -i $(BUILD)/part.img -h 32 -t 32 -n 64 -c 1

	# Copy UEFI Applications to File System
	mcopy -i $(BUILD)/part.img $(BUILD)/main.efi ::

	# Write Partition Img to Main Img
	dd if=$(BUILD)/part.img of=$(BUILD)/uefi.img bs=512 count=91669 seek=2048 conv=notrunc

qemu:
	#qemu-system-x86_64 -cpu qemu64 \
  		#-drive if=pflash,format=raw,unit=0,file=path_to_OVMF_CODE.fd,readonly=on \
  		#-drive if=pflash,format=raw,unit=1,file=path_to_OVMF_VARS.fd \
  		#-net none

	#qemu-system-x86_64 -cpu qemu64 -bios /path/to/OVMF.4m.fd -drive file=uefi.disk,if=ide
	#OVMF.fd is original, OVMF.4m.fd is updated
	qemu-system-x86_64 -cpu qemu64 -bios $(EDK2_OVMF)/x64/OVMF.4m.fd -drive file=$(BUILD)/$(QEMU_TARGET),if=ide

clean:
	# -f
	rm $(BUILD)/* || echo "Clean"