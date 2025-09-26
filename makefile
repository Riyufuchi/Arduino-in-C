# Target MCU and programmer
MCU     = atmega328p
F_CPU   = 16000000UL
BAUD    = 9600
PROGRAMMER = arduino
PORT    = /dev/ttyACM0

# Toolchain
CC      = avr-gcc
OBJCOPY = avr-objcopy
AVRDUDE = avrdude

CFLAGS  = -std=c11 -Wall -Os -DF_CPU=$(F_CPU) -mmcu=$(MCU)
LDFLAGS = -mmcu=$(MCU)

# Project
SRC_DIR = arduinoInC
BUILD_DIR = build

C_SRC_FILES := $(shell find $(SRC_DIR) -type f -name "*.c")

# Combine both .cpp and .c source files
SRC_FILES := $(C_SRC_FILES)

# Generate object file names
OBJ_FILES := $(patsubst $(SRC_DIR)/%, $(BUILD_DIR)/%, $(C_SRC_FILES:.c=.o))

# Target files
TARGET  = firmware
HEX     = $(TARGET).hex

# Default target
all: $(HEX)

$(HEX): $(TARGET).elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

$(TARGET).elf: $(OBJ_FILES)
	$(CC) $(LDFLAGS) $^ -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

flash: $(HEX)
	$(AVRDUDE) -p $(MCU) -c $(PROGRAMMER) -P $(PORT) -b 115200 -D -U flash:w:$(HEX):i

clean:
	rm -f $(OBJ_FILES) $(TARGET).elf $(HEX)
	
# Documentation
docs:
	cd latex-doc && \
	lualatex ArduinoInC.tex && \
	makeglossaries ArduinoInC && \
	lualatex ArduinoInC.tex && \
	lualatex ArduinoInC.tex

.PHONY: all clean docs

