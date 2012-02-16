#
# CMake file for pyvrui project
#

project(pyvrui)

cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

find_package(SWIG REQUIRED)
include(${SWIG_USE_FILE})

find_package(PkgConfig)

pkg_search_module(VRUI REQUIRED Vrui)
add_definitions(${VRUI_CFLAGS})

find_package(PythonLibs)

include_directories(${PYTHON_INCLUDE_PATH} ${VRUI_INCLUDE_DIRS})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)

set(CMAKE_SWIG_FLAGS "")

file(GLOB INTERFACE_FILES *.i)

set_source_files_properties(${INTERFACE_FILES} PROPERTIES CPLUSPLUS ON)

message(STATUS "VRUI_LIBRARIES=${VRUI_LIBRARIES}")
message(STATUS "VRUI_LDFLAGS=${VRUI_LDFLAGS}")

string(REPLACE "-framework;" "-framework" VRUI_LDFLAGS "${VRUI_LDFLAGS}")

swig_add_module(${PROJECT_NAME} python ${PROJECT_NAME}.i)
swig_link_libraries(${PROJECT_NAME} ${PYTHON_LIBRARIES} ${VRUI_LDFLAGS})

set(CMAKE_INSTALL_PREFIX "/usr/local")

file(GLOB SHARED_LIBRARIES ${CMAKE_BINARY_DIR}/*.so)
file(GLOB PYTHON_FILES ${CMAKE_BINARY_DIR}/*.py)

message(STATUS "SHARED_LIBRAIES=${SHARED_LIBRARIES}")
message(STATUS "PYTHON_FILES=${PYTHON_FILES}")

file(GLOB EXAMPLE_SOURCES examples/*.py)
set(EXAMPLE_RESOURCES examples/EarthTopography.png)

install(FILES ${SHARED_LIBRARIES} ${PYTHON_FILES} DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/python2.7/dist-packages)
install(FILES ${EXAMPLE_SOURCES} ${EXAMPLE_RESOURCES}  DESTINATION /usr/share/pyvrui)

set(CPACK_PACKAGE_NAME ${PROJECT_NAME})

set(PYVRUI_MAJOR_VERSION 0)
set(PYVRUI_MINOR_VERSION 1)
set(PYVRUI_PATCH_VERSION 0~0)

set(CPACK_PACKAGE_VERSION_MAJOR ${PYVRUI_MAJOR_VERSION})
set(CPACK_PACKAGE_VERSION_MINOR ${PYVRUI_MINOR_VERSION})
set(CPACK_PACKAGE_VERSION_PATCH ${PYVRUI_PATCH_VERSION})

set(CPACK_PACKAGE_VENDOR "keckcaves.org")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Python interface for VRUI library")

set(CPACK_GENERATOR DEB)

if (CMAKE_SIZEOF_VOID_P EQUAL 4)
   set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE i386)
   set(CPACK_SYSTEM_NAME "i386")
else()
   set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE amd64)
   set(CPACK_SYSTEM_NAME "amd64")
endif()

set(CPACK_DEBIAN_PACKAGE_DEPENDS "python-opengl, vrui (>=2.0)")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER jvan@cse.ucdavis.edu)

set(CPACK_SET_DESTDIR ON)

include(CPack)
message(STATUS "CPack enabled for packaging")
