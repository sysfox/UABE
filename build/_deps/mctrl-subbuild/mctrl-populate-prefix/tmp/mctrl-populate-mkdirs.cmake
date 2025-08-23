# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION ${CMAKE_VERSION}) # this file comes with cmake

# If CMAKE_DISABLE_SOURCE_CHANGES is set to true and the source directory is an
# existing directory in our source tree, calling file(MAKE_DIRECTORY) on it
# would cause a fatal error, even though it would be a no-op.
if(NOT EXISTS "/home/runner/work/UABE/UABE/fetchcontent/mctrl-src")
  file(MAKE_DIRECTORY "/home/runner/work/UABE/UABE/fetchcontent/mctrl-src")
endif()
file(MAKE_DIRECTORY
  "/home/runner/work/UABE/UABE/build/_deps/mctrl-build"
  "/home/runner/work/UABE/UABE/build/_deps/mctrl-subbuild/mctrl-populate-prefix"
  "/home/runner/work/UABE/UABE/build/_deps/mctrl-subbuild/mctrl-populate-prefix/tmp"
  "/home/runner/work/UABE/UABE/build/_deps/mctrl-subbuild/mctrl-populate-prefix/src/mctrl-populate-stamp"
  "/home/runner/work/UABE/UABE/build/_deps/mctrl-subbuild/mctrl-populate-prefix/src"
  "/home/runner/work/UABE/UABE/build/_deps/mctrl-subbuild/mctrl-populate-prefix/src/mctrl-populate-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/home/runner/work/UABE/UABE/build/_deps/mctrl-subbuild/mctrl-populate-prefix/src/mctrl-populate-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/home/runner/work/UABE/UABE/build/_deps/mctrl-subbuild/mctrl-populate-prefix/src/mctrl-populate-stamp${cfgdir}") # cfgdir has leading slash
endif()
