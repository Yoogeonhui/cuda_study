cmake_minimum_required(VERSION 3.10)

project(cuda_really_study LANGUAGES CXX CUDA)

set (CMAKE_CXX_STANDARD 17)

include(conan_build/conanbuildinfo.cmake)
conan_basic_setup()

include_directories(include)

# ${CONAN_LIBS} has all imports

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)

add_subdirectory(src)
