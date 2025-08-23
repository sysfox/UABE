# Find required frameworks/libraries based on platform
if(APPLE)
    # macOS-specific frameworks
    find_library(COCOA_LIBRARY Cocoa)
    find_library(FOUNDATION_LIBRARY Foundation)

    if(NOT COCOA_LIBRARY OR NOT FOUNDATION_LIBRARY)
        message(FATAL_ERROR "Required macOS frameworks not found")
    endif()
    
    set(PLATFORM_LIBRARIES ${COCOA_LIBRARY} ${FOUNDATION_LIBRARY})
else()
    # For other Unix systems, we don't need GUI frameworks for console mode
    set(PLATFORM_LIBRARIES)
endif()

add_library(UABE_macOS SHARED 
    macOSAppContext.cpp
    macOSAppContext.h
    api.h
)

target_include_directories(UABE_macOS PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_compile_definitions(UABE_macOS PRIVATE UABE_macOS_EXPORTS)

set_target_properties(UABE_macOS PROPERTIES 
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)

target_link_libraries(UABE_macOS PUBLIC 
    UABE_Generic 
    AssetsTools 
    libStringConverter
)

target_link_libraries(UABE_macOS PRIVATE 
    ModInstaller 
    libCompression
    ${PLATFORM_LIBRARIES}
)