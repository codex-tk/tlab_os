all: tlab_os.elf

tlab_os.elf : 
	arm-none-eabi-gcc -mcpu=cortex-a7 -fpic -ffreestanding -c ./boot/boot.S -o ./build/boot.o
	arm-none-eabi-gcc -mcpu=cortex-a7 -fpic -ffreestanding -std=gnu99 -c ./kernel/kernel.c -o ./build/kernel.o -O2 -Wall -Wextra
	arm-none-eabi-gcc -T linker.ld -o ./build/tlab_os.elf -ffreestanding -O2 -nostdlib ./build/boot.o ./build/kernel.o

clean:
	rm -f tlab_os.elf