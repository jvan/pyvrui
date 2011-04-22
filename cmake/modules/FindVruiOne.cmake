find_path(VRUIONE_INCLUDE_PATH Vrui/Application.h /usr/include/vrui-one)
find_library(VRUIONE_LIBRARIES vrui-one PATH_SUFFIXES lib64 lib)

if (VRUIONE_INCLUDE_PATH AND VRUIONE_LIBRARIES)
   set(VRUIONE_FOUND TRUE)
endif()

if (VRUIONE_FOUND)
   if (NOT VruiOne_FIND_QUIETLY)
      message(STATUS "VRUIONE_INCLUDE_PATH=${VRUIONE_INCLUDE_PATH}")
      message(STATUS "VRUIONE_LIBRARIES=${VRUIONE_LIBRARIES}")
   endif()
else()
   if (VruiOne_FIND_REQUIRED)
      message(FATAL_ERROR "Required package vrui-one NOT FOUND; try setting its path in CMAKE_PREFIX_PATH")
   endif()
endif()

