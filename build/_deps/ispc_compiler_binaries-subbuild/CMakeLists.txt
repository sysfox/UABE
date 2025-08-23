# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.31.6)

# Reject any attempt to use a toolchain file. We must not use one because
# we could be downloading it here. If the CMAKE_TOOLCHAIN_FILE environment
# variable is set, the cache variable will have been initialized from it.
unset(CMAKE_TOOLCHAIN_FILE CACHE)
unset(ENV{CMAKE_TOOLCHAIN_FILE})

# We name the project and the target for the ExternalProject_Add() call
# to something that will highlight to the user what we are working on if
# something goes wrong and an error message is produced.

project(ispc_compiler_binaries-populate NONE)



include(ExternalProject)
ExternalProject_Add(ispc_compiler_binaries-populate
                     "UPDATE_DISCONNECTED" "False" "DOWNLOAD_EXTRACT_TIMESTAMP" "TRUE" "EXTERNALPROJECT_INTERNAL_ARGUMENT_SEPARATOR" "URL" "https://github.com/ispc/ispc/releases/download/v1.17.0/ispc-v1.17.0-windows.zip" "URL_HASH" "SHA256=E9A7CC98F69357482985BCBF69FA006632CEE7B3606069B4D5E16DC62092D660"
                    SOURCE_DIR          "/home/runner/work/UABE/UABE/fetchcontent/ispc_compiler"
                    BINARY_DIR          "/home/runner/work/UABE/UABE/build/_deps/ispc_compiler_binaries-build"
                    CONFIGURE_COMMAND   ""
                    BUILD_COMMAND       ""
                    INSTALL_COMMAND     ""
                    TEST_COMMAND        ""
                    USES_TERMINAL_DOWNLOAD  YES
                    USES_TERMINAL_UPDATE    YES
                    USES_TERMINAL_PATCH     YES
)


