add_subdirectory (Utility)
add_subdirectory (TextAsset)

# Optional plugins that depend on external libraries
find_package(fmod QUIET)
if(fmod_FOUND)
    message(STATUS "FMOD found - building AudioClip plugin")
    add_subdirectory (AudioClip)
else()
    message(STATUS "FMOD not found - skipping AudioClip plugin")
endif()

add_subdirectory (Texture)
add_subdirectory (Mesh)
