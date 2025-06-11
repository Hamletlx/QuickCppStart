# QuickCppStart - 极简 C++ 项目启动模板

## 🚀项目简介

QuickCppStart 是一个极简的、跨平台的 C++ 项目模板，帮助您快速搭建规范的 C++ 项目结构。  

✅核心优势：  
* 零配置：无需任何设置，无需复杂的编译和链接命令，直接编译运行
* 双模式：内置调试/发布两种构建模式，一键切换
* 跨平台：Windows/Linux/macOS 全兼容
* 工程化：标准目录结构，适合扩展为大型项目

## 📂项目结构

```bash
QuickCppStart/
├── Makefile           # 构建系统配置（已优化，无需修改）
├── src/               # 源代码目录
│   └── main.cpp       # 示例程序（输出 Hello World）
├── include/           # 头文件目录（自动链接）
└── lib/               # 第三方库目录（自动链接）
```

## ⚡快速开始

### 1.环境要求

* GNU Make
* GCC/G++ 编译器（或兼容编译器）

### 2.克隆项目

```bash
git clont https://github.com/Hamletlx/QuickCppStart.git yourProjectName
```

### 3.构建项目（二选一）

```bash
make debug    # 调试模式（-g -O0）
make release  # 发布模式（-O2 优化）
```

### 4.运行程序（二选一）

```bash
make run_debug    # 运行调试版（快速验证）
make run_release  # 运行发布版（高性能）
```

### 5.清理构建

```bash
make clean  # 删除所有生成文件
```

## 🔧扩展项目

### 添加新文件

1. 源文件 → 放入 src/（自动编译）
2. 头文件 → 放入 include/（自动链接
3. 第三方库 → 放入 lib/，并修改 Makefile 中的 LIBS 变量

### 自定义配置

编辑 Makefile 中以下变量：

```bash
LIBS = -lyour_library  # 链接库文件（如 -pthread -lm -ldl -lrt -lz）
FLAGS += -Your_flag    # 添加其他编译选项（如 -D:定义宏 等）
```

## 💡注意事项

* Windows 平台中 MinGW 的 make 可能被修改成了 mingw32-make，可以使用 mingw32-make 替代 make 或者拷贝 mingw32-make 的副本并重命名为make
