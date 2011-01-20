#
# CMake file for pyvrui project
#

project(pyvrui)

cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

list(APPEND CMAKE_MODULE_PATH /usr/local/cmake/modules)

find_package(SWIG REQUIRED)
include(${SWIG_USE_FILE})

find_package(Vrui REQUIRED)

find_package(PythonLibs)

include_directories(${PYTHON_INCLUDE_PATH} ${VRUI_INCLUDE_DIR})

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)

file(GLOB SOURCES src/*.cpp)

set(CMAKE_SWIG_FLAGS "")

set_source_files_properties(${PROJECT_NAME}.i PROPERTIES CPLUSPLUS ON)

swig_add_module(${PROJECT_NAME} python ${PROJECT_NAME}.i  ${SOURCES})
swig_link_libraries(${PROJECT_NAME} ${PYTHON_LIBRARIES} ${VRUI_LIBRARY})

