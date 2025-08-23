# macOS Support Implementation

This directory contains the macOS-specific implementation of UABE (Asset Bundle Extractor).

## Files

- `macOSAppContext.h` / `macOSAppContext.cpp`: Main application context for macOS, similar to Win32AppContext but using POSIX/Cocoa APIs
- `MainWindow_macOS.h` / `MainWindow_macOS.mm`: Native Cocoa GUI implementation using AppKit
- `api.h`: Platform-specific API definitions
- `CMakeLists.txt`: CMake build configuration for macOS module

## Current Status

- ✅ Basic AppContext implementation with cross-platform message handling
- ✅ Cross-platform launcher integration with GUI/console mode selection
- ✅ CMake build system support with Objective-C++ compilation
- ✅ Native Cocoa GUI implementation with menu bar and main window
- ✅ Native macOS file dialogs (NSOpenPanel/NSSavePanel)
- ✅ Console-based operation for headless mode
- 🚧 File list and asset tree integration - partially implemented
- 🚧 Asset manipulation dialogs - basic placeholder implementation

## Architecture

The macOS implementation follows the same pattern as the Windows version:
1. Platform-specific `macOSAppContext` extends the generic `AppContext` base class
2. Cross-platform launcher detects the platform and loads appropriate module
3. Native GUI using Cocoa/AppKit with `MainWindow_macOS` class
4. Message passing system for thread communication
5. Plugin system integration for asset manipulation

## Building

The macOS module is automatically built when CMake detects a macOS platform. It includes:
- Objective-C++ compilation for Cocoa integration
- Automatic Reference Counting (ARC) enabled
- Cocoa and Foundation framework linking

## Usage

### GUI Mode (Default on macOS)
```bash
./UABE
```

### Console Mode
```bash
./UABE --console
# or
./UABE -c
```

## GUI Features

- Native macOS menu bar with File, Edit, and View menus
- Split-view interface with file list and asset tree
- Native file dialogs for opening and saving files
- Standard macOS application lifecycle management

## Future Enhancements

- Complete asset list and tree view data integration
- Advanced asset manipulation dialogs
- macOS-specific preferences dialog
- Integration with macOS application bundle structure
- macOS-specific keyboard shortcuts and services integration
- Dark mode support and modern macOS UI guidelines