cmake_minimum_required(VERSION 3.13)
project(BugReport VERSION 1.0)

# Emerge compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Set the path to LLVM's CMake modules
set(LLVM_DIR /usr/lib/llvm-18/cmake)

# Include LLVM's CMake modules
find_package(LLVM REQUIRED CONFIG)

# Set up LLVM-specific configurations
add_definitions(${LLVM_DEFINITIONS})

# Set the generator to Ninja
set(CMAKE_GENERATOR Ninja)

# Set the C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Set the toolchain
set(CMAKE_C_COMPILER "/usr/bin/clang-18")
set(CMAKE_CXX_COMPILER "/usr/bin/clang++-18")
set(CMAKE_LINKER "/usr/bin/clang++-18")
set(CMAKE_AR "/usr/bin/llvm-ar-18")
set(CMAKE_NM "/usr/bin/llvm-nm-18")
set(CMAKE_RANLIB "/usr/bin/llvm-ranlib-18")
set(CMAKE_OBJCOPY "/usr/bin/llvm-objcopy-18")
set(CMAKE_OBJDUMP "/usr/bin/llvm-objdump-18")
set(CMAKE_STRIP "/usr/bin/llvm-strip-18")

# Default compile options
add_compile_options(-Wall -Wextra)

# Protobuf dependency
list(APPEND CMAKE_PREFIX_PATH "/opt/protobuf")
find_package(Protobuf PATHS "/opt/protobuf" CONFIG REQUIRED)
include_directories(${Protobuf_INCLUDE_DIRS})

# Compile protobuf files
set(PROTO_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/generated")
add_library(messages OBJECT "${CMAKE_CURRENT_LIST_DIR}/src/messages.proto")
target_link_libraries(messages PUBLIC protobuf::libprotobuf)
target_include_directories(messages SYSTEM PUBLIC "$<BUILD_INTERFACE:${PROTO_BINARY_DIR}>")

protobuf_generate(
    LANGUAGE "cpp"
    TARGET messages
    IMPORT_DIRS "${CMAKE_CURRENT_LIST_DIR}"
    PROTOC_OUT_DIR "${PROTO_BINARY_DIR}"
)

# Compile main.cpp
add_executable(main src/main.cpp)
target_link_libraries(main messages)

