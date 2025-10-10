# Line Breaking Formatter

A C/C++ AST-based formatter that breaks long expressions across multiple lines.

## Building

```bash
cd build
cmake -S .. -B . -DLLVM_DIR="$(llvm-config-20 --cmakedir)" -DCMAKE_BUILD_TYPE=Debug
cmake --build . -j
```

## Usage

### Single File
```bash
# Format to stdout
./build/myfmt file.c --

# Format in-place
./build/myfmt -i file.c --

# With compilation database
./build/myfmt -p build_dir file.c --
```

### Directory (Batch Processing)
```bash
# Format all .c files in a directory
./myfmt-simple target_directory [build_directory]

# Format in-place
./myfmt-simple -i target_directory [build_directory]
```

## What it does

- Breaks binary operators (`&&`, `||`, `+`, etc.) across lines
- Breaks ternary operators (`?:`) across lines  
- Breaks long for-loop conditions across lines
- Preserves functionality and compilation

## Compilation Database

The formatter works best with a compilation database (`compile_commands.json`) that provides proper include paths and compile flags. Generate one using:

```bash
# CMake projects
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..

# Other build systems
bear -- make
```

## Notes

- Only run once per file (not idempotent)
- Use compilation database (`-p`) for best results with complex projects
- Processes `.c` files only, skips test directories
- Without compilation database, may have parsing errors on files with complex includes