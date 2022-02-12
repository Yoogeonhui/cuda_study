set(cuda_target GreyAns_Cuda)

file(GLOB_RECURSE cuda_sources ${CMAKE_CURRENT_SOURCE_DIR}/*.cu)

set(CMAKE_CUDA_ARCHITECTURES 50)

add_executable(${cuda_target} ${cuda_sources})
set_property(TARGET ${cuda_target} PROPERTY CUDA_STANDARD 14)
enable_language(CUDA)

set_target_properties(${cuda_target} PROPERTIES LINKER_LANGUAGE CUDA)
target_link_libraries(${cuda_target} PUBLIC ${CONAN_LIBS})
target_include_directories(${cuda_target} PRIVATE ${CONAN_INCLUDE_DIRS})