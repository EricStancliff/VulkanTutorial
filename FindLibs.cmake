function(FindLibs LibName IncludeOnly)
if(NOT ${IncludeOnly})
if(NOT DEFINED ${LibName}_LIB)
set(${LibName}_LIB "" CACHE FILEPATH "Library file for ${LibName}")
list(APPEND LIBRARY_VARS ${LibName}_LIB)
endif()
if(NOT DEFINED ${LibName}_BIN)
set(${LibName}_BIN "" CACHE PATH "Bin Directory for ${LibName}")
list(APPEND LIBRARY_VARS ${LibName}_BIN)
endif()
endif()
if(NOT DEFINED ${LibName}_INCLUDE)
set(${LibName}_INCLUDE "" CACHE PATH "Include directory for ${LibName}")
list(APPEND LIBRARY_VARS ${LibName}_LIB)
endif()
endfunction(FindLibs)

#function(CheckLibs)
#foreach(var IN LIBRARY_VARS)
#if(NOT ${${var}})
#message(FATAL_ERROR "Please set ${var}")
#endif()
#endforeach(var)
#endfunction(CheckLibs)