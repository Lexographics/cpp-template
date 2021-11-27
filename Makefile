TARGET_EXEC ?= Project # Project Name
PLATFORM ?= linux

BUILD_DIR ?= build/$(PLATFORM)
SRC_DIRS ?= src thirdparty

SRCS := $(shell find $(SRC_DIRS) -name "*.cpp" -or -name "*.c" -or -name "*.s")
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

ADDITIONAL_OBJS := #



INC_DIRS := $(shell find $(SRC_DIRS) -type d) include/
INC_FLAGS := $(addprefix -I,$(INC_DIRS))
LIB_DIRS := lib/ thirdparty/
LIB_FLAGS := $(addprefix -L,$(LIB_DIRS))
LDFLAGS := # Linking flags. -llibrary etc.

CFLAGS ?= $(INC_FLAGS) $(LIB_FLAGS) -Wall -g
CPPFLAGS ?= $(INC_FLAGS) $(LIB_FLAGS) -MMD -MP -std=c++17 -Wall -g

$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
	$(CXX) $(OBJS) ${LIB_FLAGS} ${ADDITIONAL_OBJS} -o $@ $(LDFLAGS)

# assembly
$(BUILD_DIR)/%.s.o: %.s
	$(MKDIR_P) $(dir $@)
	$(AS) $(ASFLAGS) -c $< -o $@

# c source
$(BUILD_DIR)/%.c.o: %.c
	$(MKDIR_P) $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

# c++ source
$(BUILD_DIR)/%.cpp.o: %.cpp
	$(MKDIR_P) $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

.PHONY: clean

clean:
	$(RM) -r build/
# $(RM) -r $(BUILD_DIR)

run:
	build/$(PLATFORM)/$(TARGET_EXEC)


-include $(DEPS)

MKDIR_P ?= mkdir -p