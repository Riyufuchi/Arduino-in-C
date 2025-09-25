# Compiler and compiler flags

# Project
SRC_DIR = arduinoInC
BUILD_DIR = build

# Find all .cpp files
CPP_SRC_FILES := $(shell find $(SRC_DIR) -type f -name "*.cpp")

C_SRC_FILES := $(shell find $(SRC_DIR) -type f -name "*.c")

# Combine both .cpp and .c source files
SRC_FILES := $(CPP_SRC_FILES) $(C_SRC_FILES)

# Generate object file names
OBJ_FILES := $(patsubst $(SRC_DIR)/%.cpp,$(BUILD_DIR)/%.o,$(SRC_FILES))

# Application name
APP_NAME = ArduinoInC
APP_TARGET = $(BUILD_DIR)/$(APP_NAME)

# Default target
all: $(APP_TARGET)

# Link executable
$(APP_TARGET): $(OBJ_FILES)
	$(CXX) $(CXXFLAGS) -o $@ $^ -L$(LIB_DIR) -I$(INC_DIR) -I/usr/include/postgresql $(CXXLIBS)

# Compile object files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp | $(BUILD_DIR)
	mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -I$(INC_DIR) -I/usr/include/postgresql -c $< -o $@

# Create build directory
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Clean target
clean:
	rm -rf $(BUILD_DIR) $(APP_TARGET) $(LIB_PATH)
	
# Documentation
docs:
	cd latex-doc && \
	lualatex ArduinoInC.tex && \
	makeglossaries ArduinoInC && \
	lualatex ArduinoInC.tex && \
	lualatex ArduinoInC.tex

.PHONY: all clean docs

