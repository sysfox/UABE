# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION ${CMAKE_VERSION}) # this file comes with cmake

if("/home/runner/work/UABE/UABE/fetchcontent/libsquish-1.15.tgz" STREQUAL "")
  message(FATAL_ERROR "LOCAL can't be empty")
endif()

if(NOT EXISTS "/home/runner/work/UABE/UABE/fetchcontent/libsquish-1.15.tgz")
  message(FATAL_ERROR "File not found: /home/runner/work/UABE/UABE/fetchcontent/libsquish-1.15.tgz")
endif()

if("SHA256" STREQUAL "")
  message(WARNING "File cannot be verified since no URL_HASH specified")
  return()
endif()

if("628796eeba608866183a61d080d46967c9dda6723bc0a3ec52324c85d2147269" STREQUAL "")
  message(FATAL_ERROR "EXPECT_VALUE can't be empty")
endif()

message(VERBOSE "verifying file...
     file='/home/runner/work/UABE/UABE/fetchcontent/libsquish-1.15.tgz'")

file("SHA256" "/home/runner/work/UABE/UABE/fetchcontent/libsquish-1.15.tgz" actual_value)

if(NOT "${actual_value}" STREQUAL "628796eeba608866183a61d080d46967c9dda6723bc0a3ec52324c85d2147269")
  message(FATAL_ERROR "error: SHA256 hash of
  /home/runner/work/UABE/UABE/fetchcontent/libsquish-1.15.tgz
does not match expected value
  expected: '628796eeba608866183a61d080d46967c9dda6723bc0a3ec52324c85d2147269'
    actual: '${actual_value}'
")
endif()

message(VERBOSE "verifying file... done")
