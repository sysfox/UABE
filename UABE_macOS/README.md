# macOS Support Implementation

This directory contains the macOS-specific implementation of UABE (Asset Bundle Extractor).

## Files

- `macOSAppContext.h` / `macOSAppContext.cpp`: Main application context for macOS, similar to Win32AppContext but using POSIX/Cocoa APIs
- `api.h`: Platform-specific API definitions
- `CMakeLists.txt`: CMake build configuration for macOS module

## Current Status

- ✅ Basic AppContext implementation with cross-platform message handling
- ✅ Cross-platform launcher integration
- ✅ CMake build system support
- ✅ Console-based operation for headless mode
- 🚧 GUI implementation (Cocoa/AppKit) - planned for future enhancement
- 🚧 File dialogs and batch import dialogs - planned for future enhancement

## Architecture

The macOS implementation follows the same pattern as the Windows version:
1. Platform-specific `macOSAppContext` extends the generic `AppContext` base class
2. Cross-platform launcher detects the platform and loads appropriate module
3. Message passing system for thread communication
4. Plugin system integration for asset manipulation

## Building

The macOS module is automatically built when CMake detects a non-Windows platform. It can run on both macOS and Linux systems in console mode.

## Future Enhancements

- Native Cocoa GUI implementation
- macOS-specific file dialogs using NSOpenPanel/NSSavePanel  
- Integration with macOS application bundle structure
- macOS-specific keyboard shortcuts and menu integration