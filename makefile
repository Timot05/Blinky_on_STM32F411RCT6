# Project dependencies
PROJECT := Blinky
BUILD_FOLDER := Debug

# Source files from Standard Peripheral Library
SPL_C_FILES = misc.c stm32f4xx_gpio.c stm32f4xx_rcc.c

# Relative path to Standard Peripheral Library
SPL_REL_PATH = libraries/STM32F4xx_StdPeriph_Driver/src

# Source files
SRC_C_FILES :=	$(wildcard *.c) \
				$(notdir $(wildcard src/*.c)) \
				$(SPL_C_FILES)

SRC_S_FILES :=	$(wildcard *.s) \
				$(notdir $(wildcard startup/*.s)) \

# Build tools
CC      = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy

# Other tools
MV = mv
CAT = cat

# Compiler options
CFLAGS  = -ggdb -O0 -Wall -Wextra -Warray-bounds -mlittle-endian
CFLAGS  += -mthumb -mcpu=cortex-m4 -mthumb-interwork

LD = ld
# Linker file / options
LFLAGS  = -Tld/STM32F411RE_FLASH.ld   #$(wildcard *.ld)
LFLAGS += --specs=nano.specs --specs=nosys.specs

# Directories to be searched for header files
INCLUDE_PATH = libraries/CMSIS/Include
INCLUDE_PATH += libraries/STM32F4xx_StdPeriph_Driver/inc
INCLUDE_PATH += src
INCLUDE_PATH += ./

# Add search path for include files to GCC
INCLUDE = $(addprefix -I,$(INCLUDE_PATH))

# Object files to be created
OBJECT_FILES = 	$(patsubst %.c, %.o, $(SRC_C_FILES)) \
				$(patsubst %.s, %.o, $(SRC_S_FILES))

# Targets to be created (object files including target folder)
OBJECTS = $(addprefix $(BUILD_FOLDER)/,$(OBJECT_FILES))

# Add Standard Peripheral Library to the build configuration
DEFS    = -DUSE_STDPERIPH_DRIVER

# Build targets
.PHONY: all
all: $(BUILD_FOLDER)/$(PROJECT).elf

$(BUILD_FOLDER)/%.o: %.c
	@$(CC) -MM $(INCLUDE) $*.c > $(BUILD_FOLDER)/$*.d
	@{ echo -n '$(BUILD_FOLDER)/'; $(CAT) $(BUILD_FOLDER)/$*.d; } >$(BUILD_FOLDER)/$*.tmp;
	@$(MV) $(BUILD_FOLDER)/$*.tmp $(BUILD_FOLDER)/$*.d
	$(CC) $(INCLUDE) $(DEFS) $(CFLAGS) -c $< -o $@

$(BUILD_FOLDER)/%.o: src/%.c
	@$(CC) -MM $(INCLUDE) src/$*.c > $(BUILD_FOLDER)/$*.d
	@{ echo -n '$(BUILD_FOLDER)/'; $(CAT) $(BUILD_FOLDER)/$*.d; } >$(BUILD_FOLDER)/$*.tmp;
	@$(MV) $(BUILD_FOLDER)/$*.tmp $(BUILD_FOLDER)/$*.d
	$(CC) $(INCLUDE) $(DEFS) $(CFLAGS) -c $< -o $@

$(BUILD_FOLDER)/startup_stm32f411xe.o: startup/startup_stm32f411xe.s
	$(CC) $(INCLUDE) $(DEFS) $(CFLAGS) -c $< -o $@

$(BUILD_FOLDER)/%.o: $(SPL_REL_PATH)/%.c
	$(CC) $(INCLUDE) $(DEFS) $(CFLAGS) -c $< -o $@

$(BUILD_FOLDER)/$(PROJECT).elf: $(OBJECTS)
	$(CC) $(INCLUDE) $(DEFS) $(CFLAGS) $(LFLAGS) -o $@ $(OBJECTS)
	$(OBJCOPY) -O binary $(BUILD_FOLDER)/$(PROJECT).elf $(BUILD_FOLDER)/$(PROJECT).bin

.PHONY: clean
clean:
	rm -f $(BUILD_FOLDER)/*.o $(BUILD_FOLDER)/*.d $(BUILD_FOLDER)/*.bin $(BUILD_FOLDER)/*.elf
