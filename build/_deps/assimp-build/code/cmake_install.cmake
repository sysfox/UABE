# Install script for directory: /home/runner/work/UABE/UABE/fetchcontent/assimp-src/code

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Debug")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set path to fallback-tool for dependency-resolution.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/runner/work/UABE/UABE/build/_deps/assimp-build/code/libassimp.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "assimp-dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/assimp" TYPE FILE FILES
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/anim.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/ai_assert.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/camera.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/color4.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/color4.inl"
    "/home/runner/work/UABE/UABE/build/_deps/assimp-build/code/../include/assimp/config.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/defs.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/Defines.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/cfileio.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/light.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/material.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/material.inl"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/matrix3x3.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/matrix3x3.inl"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/matrix4x4.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/matrix4x4.inl"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/mesh.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/postprocess.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/quaternion.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/quaternion.inl"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/scene.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/metadata.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/texture.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/types.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/vector2.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/vector2.inl"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/vector3.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/vector3.inl"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/version.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/cimport.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/importerdesc.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/Importer.hpp"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/DefaultLogger.hpp"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/ProgressHandler.hpp"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/IOStream.hpp"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/IOSystem.hpp"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/Logger.hpp"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/LogStream.hpp"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/NullLogger.hpp"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/cexport.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/Exporter.hpp"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/DefaultIOStream.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/DefaultIOSystem.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/SceneCombiner.h"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "assimp-dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/assimp/Compiler" TYPE FILE FILES
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/Compiler/pushpack1.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/Compiler/poppack1.h"
    "/home/runner/work/UABE/UABE/fetchcontent/assimp-src/code/../include/assimp/Compiler/pstdint.h"
    )
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/home/runner/work/UABE/UABE/build/_deps/assimp-build/code/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
