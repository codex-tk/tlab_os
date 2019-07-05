CC = arm-none-eabi-gcc
ARCH = cortex-a7
OBJ_DIR = ./build
ASMFLAGS = -mcpu=$(ARCH) -fpic -ffreestanding -c
CFLAGS = -mcpu=$(ARCH) -fpic -ffreestanding -std=gnu99 -c -O2 -Wall -Wextra

IMG_NAME = tlab_os.img

SRC_DIR = ./srcs
ASM_SRC_DIR = $(SRC_DIR)/asm

C_SRCS = $(wildcard $(SRC_DIR)/*.c)
ASM_SRCS = $(wildcard $(ASM_SRC_DIR)/*.S)

TARGET_OBJS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(C_SRCS))
TARGET_OBJS += $(patsubst $(ASM_SRC_DIR)/%.S, $(OBJ_DIR)/%.o, $(ASM_SRCS))

all: $(IMG_NAME)

$(OBJ_DIR)/%.o : $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o : $(ASM_SRC_DIR)/%.S
	$(CC) $(ASMFLAGS) -c $< -o $@

$(IMG_NAME) : $(TARGET_OBJS)
	$(CC) -T linker.ld -o $(IMG_NAME) -ffreestanding -O2 -nostdlib $(OBJ_DIR)/*.o

clean:
	rm -f $(TARGET_OBJS)
	rm -f $(IMG_NAME)

run: $(IMG_NAME)
	qemu-system-arm -m 256 -M raspi2 -serial stdio -kernel $(IMG_NAME)