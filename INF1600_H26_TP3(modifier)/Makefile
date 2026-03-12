# Compiles assembly and C++ files
# Abdul-W. Chaarani 2024  
CXX = g++
CXXFLAGS = -m32 -g
AS = gcc
ASFLAGS = -m32 -g

SRC_DIR = src
BUILD_DIR = build
INCLUDE_DIR = include
UTILS_DIR = utils

SRCS_CPP = $(shell find $(SRC_DIR) -name '*.cpp')
SRCS_ASM = $(shell find $(SRC_DIR) -name '*.s')
UTILS_CPP = $(UTILS_DIR)/utils.cpp

SRCS_CPP_MAIN = $(SRCS_CPP)
SRCS_ASM_MAIN = $(SRCS_ASM)

SRCS_CPP_TEST = $(SRCS_CPP)
SRCS_ASM_TEST = $(filter-out $(SRC_DIR)/main.s, $(SRCS_ASM))

OBJS_CPP_MAIN = $(SRCS_CPP_MAIN:$(SRC_DIR)/%.cpp=$(BUILD_DIR)/%.o)
OBJS_ASM_MAIN = $(SRCS_ASM_MAIN:$(SRC_DIR)/%.s=$(BUILD_DIR)/%.o)
OBJS_MAIN = $(OBJS_CPP_MAIN) $(OBJS_ASM_MAIN) $(BUILD_DIR)/utils/utils.o

OBJS_CPP_TEST = $(SRCS_CPP_TEST:$(SRC_DIR)/%.cpp=$(BUILD_DIR)/%.o)
OBJS_ASM_TEST = $(SRCS_ASM_TEST:$(SRC_DIR)/%.s=$(BUILD_DIR)/%.o)
OBJS_TEST = $(OBJS_CPP_TEST) $(OBJS_ASM_TEST) $(BUILD_DIR)/utils/utils.o $(BUILD_DIR)/utils/tests.o

TARGET = $(BUILD_DIR)/filters
TARGET_TEST = $(BUILD_DIR)/tests

CPPFLAGS = -I$(INCLUDE_DIR)

all: $(TARGET)

$(TARGET): $(OBJS_MAIN)
	@mkdir -p $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $^

test: $(TARGET_TEST)
	./$(TARGET_TEST)

$(TARGET_TEST): $(OBJS_TEST)
	@mkdir -p $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $^

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c $< -o $@

$(BUILD_DIR)/utils/%.o: $(UTILS_DIR)/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.s
	@mkdir -p $(dir $@)
	$(AS) $(ASFLAGS) -c $< -o $@

clean:
	rm -rf $(BUILD_DIR)
	rm -f *.bmp *.jpg *.jpeg *.png *.tga

run: $(TARGET)
	./$(TARGET)

zip: clean
	zip -r INF1600_remise_TP3.zip . -x "*.zip" ".git/*" ".git"

remise: clean zip

.PHONY: all clean run test clean zip remise