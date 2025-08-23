# GitHub Workflows

This directory contains GitHub Actions workflows for UABE (Asset Bundle Extractor).

## Workflows

### 1. CI (`ci.yml`)
- **Trigger**: Every push and pull request
- **Purpose**: Quick configuration check on Ubuntu
- **What it does**: Verifies CMake configuration works and attempts basic build

### 2. Build and Test (`build-test.yml`)  
- **Trigger**: Pushes/PRs to main branches (main, master, develop)
- **Purpose**: Full build testing on Windows and macOS
- **What it does**: 
  - Builds on Windows (MSVC) and macOS (Clang)
  - Creates build artifacts
  - Performs basic executable validation
  - Uploads artifacts for testing

### 3. Release (`release.yml`)
- **Trigger**: Manual dispatch only
- **Purpose**: Create official releases
- **What it does**:
  - Builds release versions for Windows and macOS
  - Creates compressed archives (.zip for Windows, .tar.gz for macOS)
  - Creates GitHub release with binaries attached
  - Includes version information and release notes

## Usage

### Creating a Release
1. Go to the Actions tab in GitHub
2. Select "Create Release" workflow
3. Click "Run workflow"
4. Enter version (e.g., "v1.0.0") 
5. Choose whether to mark as pre-release
6. Click "Run workflow"

The workflow will build for both platforms and create a release with downloadable binaries.

## Platform Support

- **Windows**: Full support with original Win32 GUI
- **macOS**: Console-based implementation (ready for future GUI development)
- **Linux**: Basic support through macOS implementation (CI testing only)