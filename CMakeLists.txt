cmake_minimum_required(VERSION 3.4)
project(Vulkan1)

set (CMAKE_CXX_STANDARD 17)

include(FindLibs.cmake)

FindLibs(GLFW FALSE)
FindLibs(GLM TRUE)
FindLibs(VULKAN FALSE)
#CheckLibs()

set(Vulkan1_includes
	VulkanApp.h
)

set(Vulkan1_source
    main.cpp
	VulkanApp.cpp
)

set(Vulkan1_shaders
	./shaders/SimpleTriangle.vert
	./shaders/SimpleTriangle.frag
)

add_executable(Vulkan1 ${Vulkan1_includes} ${Vulkan1_source})
#source_group("Shaders" FILES ${Vulkan1_shaders})

target_link_libraries(Vulkan1 ${GLFW_LIB} ${VULKAN_LIB})
target_include_directories(Vulkan1 PUBLIC ${GLFW_INCLUDE} ${GLM_INCLUDE} ${VULKAN_INCLUDE})

configure_file(Vulkan1.vcxproj.user.in ${CMAKE_BINARY_DIR}/Vulkan1.vcxproj.user @ONLY) 
add_custom_target(Shaders ALL SOURCES ${Vulkan1_shaders} DEPENDS ${Vulkan1_shaders})

set(SHADERS_DIR "${CMAKE_SOURCE_DIR}/shaders")
if(WIN32)
STRING(REGEX REPLACE "/" "\\\\" SHADERS_DIR ${SHADERS_DIR})
endif()

configure_file(./shaders/CompileShaders.bat.in ${CMAKE_BINARY_DIR}/CompileShaders.bat @ONLY) 

add_custom_command(TARGET Shaders POST_BUILD DEPENDS ${Vulkan1_shaders}
    COMMAND ${CMAKE_BINARY_DIR}/CompileShaders.bat
)