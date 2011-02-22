#
# CMake file for pyvrui project
#

project(pyvrui)

cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/modules)

find_package(SWIG REQUIRED)
include(${SWIG_USE_FILE})

message(STATUS "PROJECT_SOURCE_DIR=${PROJECT_SOURCE_DIR}")

find_package(Vrui REQUIRED)

message(STATUS "VRUI_INCLUDE_DIR=${VRUI_INCLUDE_DIR}")
message(STATUS "VRUI_LIBRARY=${VRUI_LIBRARY}")

find_package(PythonLibs)

include_directories(${PYTHON_INCLUDE_PATH} ${VRUI_INCLUDE_DIR})

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)

set(CMAKE_SWIG_FLAGS "")

file(GLOB INTERFACE_FILES *.i)

message(STATUS " -- INTERFACE_FILES=${INTERFACE_FILES}")

set_source_files_properties(${INTERFACE_FILES} PROPERTIES CPLUSPLUS ON)

swig_add_module(${PROJECT_NAME} python ${PROJECT_NAME}.i)
swig_link_libraries(${PROJECT_NAME} ${PYTHON_LIBRARIES} ${VRUI_LIBRARY})

