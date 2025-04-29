# =============================================================================
# Makefile Usage Guide
# =============================================================================
# Quick Commands:
#   make help               # Show usage
#   make [debug/d]          # Build debug version
#   make [release/r]        # Build release version
#   make [run_debug/rd]     # Run debug build
#   make [run_release/rr]   # Run release build
#   make clean              # Clean all build artifacts
# =============================================================================


# --------------------------------------
# Core Configuration
# --------------------------------------
# project configuration
MAIN := main
SRC := src
INCLUDE := include
LIB := lib

# Libraries to link (e.g., -lmylib)
LIBS :=

# other flags
FLAGS :=


# --------------------------------------
# System Adaptation (Auto-detect OS)
# --------------------------------------
ifeq ($(OS),Windows_NT)
MAIN := $(MAIN).exe
RM := del /q /f
MD := mkdir
RMDIR := rmdir /s /q
FIXPATH = $(subst /,\,$1)
else
MAIN := $(MAIN)
RM := rm -f
MD := mkdir -p
RMDIR := rm -rf
FIXPATH = $1
endif


# --------------------------------------
# Compiler Settings
# --------------------------------------
# Compiler
CXX = g++

# Base flags (C++17 + warnings)
CXXFLAGS := -std=c++17 -Wall -Wextra -Wpedantic -Wshadow -Wconversion

# Debug build flags (-g for debug symbols, -O0 for no optimization)
DEBUG_FLAGS := -g -O0

# Release build flags (-O2 optimization)
RELEASE_FLAGS := -O2


# --------------------------------------
# Build Structure
# --------------------------------------
# Debug build directories
BUILD_DEBUG_OBJ := build/debug/obj
BUILD_DEBUG_BIN := build/debug/bin

# Release build directories
BUILD_RELEASE_OBJ := build/release/obj
BUILD_RELEASE_BIN := build/release/bin

# Auto-detect all .cpp source files
SOURCES := $(wildcard $(SRC)/*.cpp)

# Generate object file paths for Debug/Release
BUILD_DEBUG_OBJ_OBJECTS := $(patsubst $(SRC)/%.cpp,$(BUILD_DEBUG_OBJ)/%.o,$(SOURCES))
BUILD_RELEASE_OBJ_OBJECTS := $(patsubst $(SRC)/%.cpp,$(BUILD_RELEASE_OBJ)/%.o,$(SOURCES))

# Generate dependency file path for Debug/Release
BUILD_DEBUG_OBJ_DEPENDENCIES := $(patsubst $(BUILD_DEBUG_OBJ)/%.o,$(BUILD_DEBUG_OBJ)/%.d,$(BUILD_DEBUG_OBJ_OBJECTS))
BUILD_RELEASE_OBJ_DEPENDENCIES := $(patsubst $(BUILD_RELEASE_OBJ)/%.o,$(BUILD_RELEASE_OBJ)/%.d,$(BUILD_RELEASE_OBJ_OBJECTS))

# Include dependency file
-include $(BUILD_DEBUG_OBJ_DEPENDENCIES)
-include $(BUILD_RELEASE_OBJ_DEPENDENCIES)

# --------------------------------------
# Help Target (default target)
# --------------------------------------
.PHONY: help
help:
	@echo Usage:
	@echo   make [debug/d]          - Build debug version
	@echo   make [release/r]        - Build release version
	@echo   make [run_debug/rd]     - Run debug build
	@echo   make [run_release/rr]   - Run release build
	@echo   make clean              - Clean all build artifacts


# --------------------------------------
# Compile Target
# --------------------------------------
# Rule to create build directories
$(BUILD_DEBUG_OBJ) $(BUILD_DEBUG_BIN) $(BUILD_RELEASE_OBJ) $(BUILD_RELEASE_BIN):
	@$(MD) $(call FIXPATH,$@)
	@echo [SYS]  mkdir $@

# Debug object compilation rule
$(BUILD_DEBUG_OBJ)/%.o: $(SRC)/%.cpp $(BUILD_DEBUG_OBJ)
	@$(CXX) $(CXXFLAGS) $(DEBUG_FLAGS) -I$(INCLUDE) -c -MMD $< -o $@
	@echo [DEBUG]  Compiled $< into $@

# Release object compilation rule
$(BUILD_RELEASE_OBJ)/%.o: $(SRC)/%.cpp $(BUILD_RELEASE_OBJ)
	@$(CXX) $(CXXFLAGS) $(RELEASE_FLAGS) -I$(INCLUDE) -c -MMD $< -o $@
	@echo [RELEASE]  Compiled $< into $@


# --------------------------------------
# Link Targets
# --------------------------------------
.PHONY: debug d release r
# Debug linking target
debug d $(BUILD_DEBUG_BIN)/$(MAIN): $(BUILD_DEBUG_OBJ_OBJECTS) $(BUILD_DEBUG_BIN)
	@$(CXX) $(CXXFLAGS) $(DEBUG_FLAGS) -I$(INCLUDE) -L$(LIB) -o $(BUILD_DEBUG_BIN)/$(MAIN) $(BUILD_DEBUG_OBJ_OBJECTS) $(LIBS) $(FLAGS)
	@echo [DEBUG]  Linked $(BUILD_DEBUG_BIN)/$(MAIN) with $(BUILD_DEBUG_OBJ_OBJECTS) $(LIBS)

# Release linking target
release r $(BUILD_RELEASE_BIN)/$(MAIN): $(BUILD_RELEASE_OBJ_OBJECTS) $(BUILD_RELEASE_BIN)
	@$(CXX) $(CXXFLAGS) $(RELEASE_FLAGS) -I$(INCLUDE) -L$(LIB) -o $(BUILD_RELEASE_BIN)/$(MAIN) $(BUILD_RELEASE_OBJ_OBJECTS) $(LIBS) $(FLAGS)
	@echo [RELEASE]  Linked $(BUILD_RELEASE_BIN)/$(MAIN) with $(BUILD_RELEASE_OBJ_OBJECTS) $(LIBS)


# --------------------------------------
# Execution Targets
# --------------------------------------
.PHONY: run_debug rd run_release rr
# Run debug executable
run_debug rd: $(BUILD_DEBUG_BIN)/$(MAIN)
	@echo [SYS]  Running Debug version...
	@$(BUILD_DEBUG_BIN)/$(MAIN)

# Run release executable
run_release rr: $(BUILD_RELEASE_BIN)/$(MAIN)
	@echo [SYS]  Running Release version...
	@$(BUILD_RELEASE_BIN)/$(MAIN)


# --------------------------------------
# Clean Target
# --------------------------------------
.PHONY: clean
clean:
	@$(RMDIR) build
	@$(MD) build
	@echo [SYS]  Cleaned all build artifacts
