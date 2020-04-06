cmake_minimum_required(VERSION 3.7 FATAL_ERROR)
project(Vulkan1)

set (CMAKE_CXX_STANDARD 17)

#get GLFW and add it to our build
include(FetchContent)
FetchContent_Declare(
  GLFW
  GIT_REPOSITORY https://github.com/glfw/glfw.git
  GIT_TAG        3.3.2
)
FetchContent_MakeAvailable(GLFW)

#get glm and make it available to include
include(ExternalProject)
ExternalProject_Add(
    glm
    PREFIX ${CMAKE_BINARY_DIR}/glm
    GIT_REPOSITORY https://github.com/g-truc/glm.git
	GIT_TAG        0.9.9.7
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    LOG_DOWNLOAD ON
    )
ExternalProject_Get_Property(glm source_dir)
set(GlmIncludeDir ${source_dir})

#get stb and make it available to include
ExternalProject_Add(
    stb
    PREFIX ${CMAKE_BINARY_DIR}/stb
    GIT_REPOSITORY https://github.com/nothings/stb.git
	GIT_TAG        origin/master
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    LOG_DOWNLOAD ON
    )
ExternalProject_Get_Property(stb source_dir)
set(StbIncludeDir ${source_dir})

find_package(Vulkan REQUIRED)

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
add_dependencies(Vulkan1 glfw glm stb Vulkan::Vulkan)
target_compile_definitions(Vulkan1 PRIVATE VK_USE_PLATFORM_WIN32_KHR)
target_link_libraries(Vulkan1 glfw Vulkan::Vulkan)
target_include_directories(Vulkan1 PRIVATE ${GLFW_SOURCE_DIR}/include ${GlmIncludeDir} ${StbIncludeDir} Vulkan_INCLUDE_DIR)

add_custom_target(Shaders ALL SOURCES ${Vulkan1_shaders} DEPENDS ${Vulkan1_shaders})

set(SHADERS_DIR "${CMAKE_SOURCE_DIR}/shaders")
if(WIN32)
STRING(REGEX REPLACE "/" "\\\\" SHADERS_DIR ${SHADERS_DIR})
endif()

configure_file(./shaders/CompileShaders.bat.in ${CMAKE_BINARY_DIR}/CompileShaders.bat @ONLY) 

add_custom_command(TARGET Shaders POST_BUILD DEPENDS ${Vulkan1_shaders}
    COMMAND ${CMAKE_BINARY_DIR}/CompileShaders.bat
)

set(TEXTURES_DIR ${CMAKE_SOURCE_DIR}/textures)
set(SHADERS_DIR ${CMAKE_SOURCE_DIR}/shaders)
set(OUTPUT_COPY_DIR ${CMAKE_CURRENT_BINARY_DIR})
if(WIN32)
STRING(REGEX REPLACE "/" "\\\\" TEXTURES_DIR ${TEXTURES_DIR})
STRING(REGEX REPLACE "/" "\\\\" SHADERS_DIR ${SHADERS_DIR})
STRING(REGEX REPLACE "/" "\\\\" OUTPUT_COPY_DIR ${OUTPUT_COPY_DIR})
add_custom_command(TARGET Vulkan1 POST_BUILD
    COMMAND xcopy /i /s /y "${TEXTURES_DIR}" "${OUTPUT_COPY_DIR}\\$<CONFIGURATION>\\textures"
)
add_custom_command(TARGET Vulkan1 POST_BUILD
    COMMAND xcopy /i /s /y "${SHADERS_DIR}\\*.spv" "${OUTPUT_COPY_DIR}\\$<CONFIGURATION>\\shaders"
)
set_target_properties(Vulkan1 PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY "$<TARGET_FILE_DIR:Vulkan1>"
                                                   VS_DEBUGGER_COMMAND           "$<TARGET_FILE:Vulkan1>"
                                                   VS_DEBUGGER_ENVIRONMENT       "PATH=%PATH%;${CMAKE_PREFIX_PATH}/bin")
else()
add_custom_command(TARGET Vulkan1 POST_BUILD
    COMMAND cp "${TEXTURES_DIR}" "${OUTPUT_COPY_DIR}/textures"
)
add_custom_command(TARGET Vulkan1 POST_BUILD
    COMMAND cp "${SHADERS_DIR}" "${OUTPUT_COPY_DIR}/shaders"
)
endif()