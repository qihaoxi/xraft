# xraft

raft library in c

## CMake layout

The project now uses modular CMake files under `cmake/`:

- `XraftOptions.cmake`: global build options and cache switches
- `XraftCompilerFlags.cmake`: warning levels and default target settings
- `XraftLinkOptions.cmake`: linker-specific flags
- `XraftSanitizers.cmake`: Address/UB/Thread/Memory sanitizer integration
- `XraftTesting.cmake`: optional test subdirectory wiring
- `XraftExamples.cmake`: optional example subdirectory wiring
- `XraftInstall.cmake`: install/export/package-config generation

## Common configure options

```bash
cmake -S . -B build
cmake -S . -B build -DBUILD_TESTING=ON -DXRAFT_BUILD_EXAMPLES=ON
cmake -S . -B build -DXRAFT_ENABLE_STRICT_CHECKS=ON
cmake -S . -B build -DXRAFT_ENABLE_ASAN=ON -DXRAFT_ENABLE_UBSAN=ON
```

For compatibility with the previous build style, `STRICT_CHECKS=ON` is also accepted and mapped to `XRAFT_ENABLE_STRICT_CHECKS=ON`.

## Source layout notes

`src/`, `tests/`, and `examples/` each contain a small `CMakeLists.txt` scaffold so you can drop in `*.c` files and have targets created automatically.

If `src/` only contains public headers such as `src/debug.h`, the build still creates the `xraft` target as an interface library so downstream code can already link against `xraft::xraft`.

## Install and package usage

Install the project:

```bash
cmake -S . -B build
cmake --build build
cmake --install build --prefix /tmp/xraft-install
```

Consume it from another CMake project:

```cmake
find_package(xraft CONFIG REQUIRED)
target_link_libraries(your_target PRIVATE xraft::xraft)
```
