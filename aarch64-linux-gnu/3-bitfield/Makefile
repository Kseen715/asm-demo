AS = as
LD = ld
LDFLAGS += -lc -dynamic-linker /lib/ld-linux-aarch64.so.1

BUILD_DIR = build
SOURCE = $(wildcard *.s)
OBJECTS = $(patsubst %.s,%.o,$(SOURCE))
OBJECTS := $(addprefix $(BUILD_DIR)/,$(OBJECTS))

OUTPUT = bitfield

OUTPUT := $(BUILD_DIR)/$(OUTPUT)

main: $(OUTPUT)

# Link object files into executable
$(OUTPUT): $(OBJECTS)
	$(LD) -o $@ $^ $(LDFLAGS)

# Assemble source files into object files
$(BUILD_DIR)/%.o: %.s build_dir
	$(AS) -o $@ $<

build_dir:
	@if [ ! -d $(BUILD_DIR) ]; then mkdir -p $(BUILD_DIR); fi

run: $(OUTPUT)
	./$(OUTPUT)

clean:
	rm -rf $(BUILD_DIR)

.PHONY: main clean run