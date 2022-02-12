set(target Fractal)
set(cuda_target Fractal_Cuda)

file(GLOB_RECURSE cuda_sources ${CMAKE_CURRENT_SOURCE_DIR}/*.cu)

file(GLOB_RECURSE sources ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp)

set(CMAKE_CUDA_ARCHITECTURES 50)

add_library(${cuda_target} ${cuda_sources})
set_property(TARGET ${cuda_target} PROPERTY CUDA_STANDARD 11)
enable_language(CUDA)

set_target_properties(${cuda_target} PROPERTIES LINKER_LANGUAGE CUDA)

add_executable(${target} ${sources})

message(${CONAN_LIBS})

target_link_libraries(${target} PUBLIC ${cuda_target} cuda cudart ${CONAN_LIBS} m c)
target_include_directories(${target} PRIVATE ${CONAN_INCLUDE_DIRS})