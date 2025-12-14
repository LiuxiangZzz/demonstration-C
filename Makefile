# 编译器设置
CC = gcc
CFLAGS = -Wall -Wextra -g -std=c11
INCLUDES = -Iinclude
LDFLAGS = 

# 目录设置
SRC_DIR = src
INCLUDE_DIR = include
BUILD_DIR = build
OBJ_DIR = $(BUILD_DIR)/object
ASM_DIR = $(BUILD_DIR)/assemble
OBJDUMP_DIR = $(BUILD_DIR)/objdump

# 源文件和目标文件
SOURCES = $(wildcard $(SRC_DIR)/*.c)
OBJECTS = $(SOURCES:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)
ASSEMBLY = $(SOURCES:$(SRC_DIR)/%.c=$(ASM_DIR)/%.s)
OBJDUMP_FILES = $(SOURCES:$(SRC_DIR)/%.c=$(OBJDUMP_DIR)/%.dump)

# 最终可执行文件
TARGET = demo

# 默认目标
all: $(TARGET)

# 创建目录
$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(ASM_DIR):
	mkdir -p $(ASM_DIR)

$(OBJDUMP_DIR):
	mkdir -p $(OBJDUMP_DIR)

# 编译可执行文件
$(TARGET): $(OBJECTS) | $(OBJ_DIR)
	$(CC) $(OBJECTS) -o $(TARGET) $(LDFLAGS)
	@echo "构建完成: $(TARGET)"

# 编译目标文件
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

# 生成汇编文件
$(ASM_DIR)/%.s: $(SRC_DIR)/%.c | $(ASM_DIR)
	$(CC) $(CFLAGS) $(INCLUDES) -S $< -o $@

# 生成反汇编文件
$(OBJDUMP_DIR)/%.dump: $(OBJ_DIR)/%.o | $(OBJDUMP_DIR)
	objdump -d -S $< > $@

# 生成所有汇编文件
assembly: $(ASSEMBLY)
	@echo "汇编文件已生成到 $(ASM_DIR)"

# 生成所有反汇编文件
objdump: $(OBJDUMP_DIR) $(OBJECTS) $(OBJDUMP_FILES) $(TARGET)
	@echo "生成可执行文件反汇编..."
	@if [ -f $(TARGET) ]; then \
		objdump -d -S $(TARGET) > $(OBJDUMP_DIR)/$(TARGET).dump; \
		echo "✅ 可执行文件 $(TARGET) 的反汇编已生成到 $(OBJDUMP_DIR)/$(TARGET).dump"; \
	else \
		echo "⚠️  警告：$(TARGET) 不存在，请先运行 make"; \
	fi
	@echo "反汇编文件已生成到 $(OBJDUMP_DIR)"

# 清理（保留目录结构，只删除文件）
clean:
	@mkdir -p $(BUILD_DIR) $(OBJ_DIR) $(ASM_DIR) $(OBJDUMP_DIR)
	@if [ -d $(BUILD_DIR) ]; then \
		find $(BUILD_DIR) -type f -delete; \
	fi
	rm -f $(TARGET)
	@echo "清理完成（目录结构已保留）"

# 完全清理（包括可执行文件）
distclean: clean
	rm -f $(TARGET)

# 显示符号表
symbols: $(TARGET)
	@echo "=== 可执行文件符号表 ==="
	nm $(TARGET)
	@echo "\n=== 使用readelf查看符号 ==="
	readelf -s $(TARGET)

# 显示目标文件符号
obj-symbols: $(OBJECTS)
	@echo "=== 目标文件符号表 ==="
	@for obj in $(OBJECTS); do \
		echo "\n--- $$obj ---"; \
		nm $$obj; \
	done

# 生成 compile_commands.json（用于编辑器 IntelliSense）
compile_commands:
	@echo "生成 compile_commands.json..."
	@echo "[" > compile_commands.json
	@first=true; \
	for src in $(SOURCES); do \
		file=$$src; \
		obj=$$(echo $$src | sed 's|$(SRC_DIR)|$(OBJ_DIR)|' | sed 's|\.c$$|.o|'); \
		cmd="$(CC) $(CFLAGS) $(INCLUDES) -c $$file -o $$obj"; \
		if [ "$$first" = "true" ]; then \
			first=false; \
		else \
			echo "," >> compile_commands.json; \
		fi; \
		echo "  {" >> compile_commands.json; \
		echo "    \"directory\": \"$$(pwd)\"," >> compile_commands.json; \
		echo "    \"command\": \"$$cmd\"," >> compile_commands.json; \
		echo "    \"file\": \"$$file\"" >> compile_commands.json; \
		echo -n "  }" >> compile_commands.json; \
	done; \
	echo "" >> compile_commands.json; \
	echo "]" >> compile_commands.json
	@echo "✅ compile_commands.json 已生成"

# 帮助信息
help:
	@echo "可用的make目标:"
	@echo "  all                - 编译项目（默认）"
	@echo "  compile_commands   - 生成 compile_commands.json（用于编辑器）"
	@echo "  assembly           - 生成汇编文件到 $(ASM_DIR)"
	@echo "  objdump            - 生成反汇编文件到 $(OBJDUMP_DIR)"
	@echo "  symbols            - 显示可执行文件的符号表"
	@echo "  obj-symbols        - 显示所有目标文件的符号表"
	@echo "  clean              - 清理构建文件"
	@echo "  distclean          - 完全清理（包括可执行文件）"
	@echo "  help               - 显示此帮助信息"

.PHONY: all clean distclean assembly objdump symbols obj-symbols compile_commands help

