cmake_minimum_required(VERSION 3.4)
project(Vulkan1)

set (CMAKE_CXX_STANDARD 17)

include(FindLibs.cmake)

FindLibs(GLFW FALSE)
FindLibs(GLM TRUE)
FindLibs(VULKAN FALSE)
#CheckLibs()

set(Vulkan1_includes

)

set(Vulkan1_source
    main.cpp
)

set(Vulkan1_shaders
	SimpleTriangle.glsl.vert
	SimpleTriangle.glsl.frag
)

add_executable(Vulkan1 ${Vulkan1_includes} ${Vulkan1_source})

source_group("Shaders" FILES ${Vulkan1_shaders})

target_link_libraries(Vulkan1 ${GLFW_LIB} ${VULKAN_LIB})
target_include_directories(Vulkan1 PUBLIC ${GLFW_INCLUDE} ${GLM_INCLUDE} ${VULKAN_INCLUDE})

configure_file(Vulkan1.vcxproj.user.in ${CMAKE_BINARY_DIR}/Vulkan1.vcxproj.user @ONLY) 