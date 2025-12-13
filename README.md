# 典韦 vs 曹操 决斗系统

一个基于 C 语言的回合制战斗系统演示项目。

## 项目简介

本项目实现了一个简单的回合制战斗系统，模拟典韦与曹操之间的决斗。系统包含攻击、闪避、暴击等战斗机制，并按照攻速决定攻击顺序。

## 文件目录结构

```
C/
├── src/                    # 源代码目录
│   ├── main.c             # 主程序入口，包含战斗循环逻辑
│   └── battle.c           # 战斗系统实现（角色初始化、攻击、状态显示等）
├── include/               # 头文件目录
│   ├── battle.h           # 战斗系统头文件（角色结构体、函数声明）
│   └── common.h           # 公共头文件（常量定义、标准库包含）
├── build/                 # 构建输出目录
│   ├── object/            # 目标文件（.o）
│   ├── assemble/          # 汇编文件（.s）
│   └── objdump/           # 反汇编文件（.dump）
├── .vscode/               # VSCode 配置文件
│   ├── settings.json      # 编辑器设置
│   ├── c_cpp_properties.json  # C/C++ 扩展配置
│   ├── launch.json        # 调试配置
│   └── tasks.json         # 构建任务配置
├── Makefile               # 构建脚本
├── compile_commands.json  # 编译命令数据库（用于 IntelliSense）
├── demo                   # 编译生成的可执行文件
└── README.md              # 本文件
```

## 开发环境

### 必需工具

- **编译器**: GCC (GNU Compiler Collection)
  - 版本要求: 支持 C11 标准
  - 检查命令: `gcc --version`
  
- **调试器**: GDB (GNU Debugger)
  - 版本要求: 支持 pretty-printing
  - 检查命令: `gdb --version`

- **构建工具**: Make
  - 检查命令: `make --version`

- **其他工具**:
  - `objdump`: 用于生成反汇编文件
  - `nm`: 用于查看符号表
  - `readelf`: 用于查看 ELF 文件信息

### 编译选项

项目使用以下编译选项（定义在 `Makefile` 中）：

- `-Wall`: 启用所有常见警告
- `-Wextra`: 启用额外警告
- `-g`: 生成调试信息
- `-std=c11`: 使用 C11 标准
- `-Iinclude`: 包含头文件目录

## VSCode 插件配置

项目使用了以下 VSCode 插件：

### 1. C/C++ (ms-vscode.cpptools)
- **用途**: 提供 C/C++ 语言支持、IntelliSense、代码导航
- **配置文件**: `.vscode/c_cpp_properties.json`
- **功能**:
  - 代码自动补全
  - 语法高亮
  - 错误检测
  - 使用 `compile_commands.json` 进行智能感知

### 2. C/C++ Runner (danielpinto8zz6.c-cpp-runner)
- **用途**: 快速编译和运行 C/C++ 程序
- **配置文件**: `.vscode/settings.json`
- **功能**:
  - 一键编译运行
  - 自定义编译选项
  - 警告配置

### 3. 内置任务和调试支持
- **配置文件**: `.vscode/tasks.json` 和 `.vscode/launch.json`
- **功能**:
  - 集成 Make 构建任务
  - GDB 调试配置
  - 断点调试支持

## GDB 调试配置

### 调试配置说明

项目在 `.vscode/launch.json` 中配置了两个调试会话：

#### 1. "debug demo" 配置
- **类型**: `cppdbg`
- **程序**: `${workspaceFolder}/demo`
- **调试器**: GDB (`/usr/bin/gdb`)
- **前置任务**: 自动执行 `build` 任务编译项目
- **GDB 设置**:
  - 启用 pretty-printing（美化结构体输出）
  - 反汇编风格设置为 Intel

#### 2. "C/C++ Runner: Debug Session" 配置
- 由 C/C++ Runner 插件自动生成
- 用于插件内置的调试功能

### 使用 GDB 调试

#### 在 VSCode 中调试
1. 按 `F5` 或点击调试按钮启动调试
2. 设置断点：在代码行号左侧点击
3. 使用调试工具栏控制执行：
   - 继续 (F5)
   - 单步跳过 (F10)
   - 单步进入 (F11)
   - 单步跳出 (Shift+F11)
   - 重启 (Ctrl+Shift+F5)
   - 停止 (Shift+F5)
```bash
# 编译项目（确保包含调试信息）
make

### 基本构建命令

```bash
# 编译项目（默认目标）
make

# 清理构建文件
make clean

# 完全清理（包括可执行文件）
make distclean

# 重新构建
make clean all
```

### 其他有用的命令

```bash
# 生成汇编文件
make assembly

# 生成反汇编文件
make objdump

# 显示符号表
make symbols

# 显示目标文件符号
make obj-symbols

# 生成 compile_commands.json（用于编辑器 IntelliSense）
make compile_commands

# 显示帮助信息
make help
```

### 运行程序

```bash
# 直接运行
./demo


## 项目特性

### 战斗系统
- 回合制战斗机制
- 基于攻速的攻击顺序
- 攻击、闪避、暴击系统
- 伤害波动（80%-120%）
- 实时状态显示

### 角色属性
- **典韦**: 攻击力 25，攻速 8
- **曹操**: 攻击力 20，攻速 10

### 战斗参数
- 最大血量: 100
- 暴击率: 15%
- 暴击伤害: 200%
- 闪避率: 10%


## 许可证

本项目仅用于学习和演示目的。

