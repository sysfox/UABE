#include <string>
#include <cstring>
#include <vector>
#include <filesystem>

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <Windows.h>
#include <tchar.h>
#include "../libStringConverter/convert.h"
#include "../UABE_Win32/Win32AppContext.h"

static std::string getModuleBaseDir(HINSTANCE hInstance)
{
    std::string baseDir;
    std::vector<TCHAR> baseDirT;
    size_t ownPathLen = MAX_PATH;
    while (true)
    {
        baseDirT.resize(ownPathLen + 1, 0);
        SetLastError(0);
        DWORD result = GetModuleFileName(hInstance, baseDirT.data(), (DWORD)ownPathLen);
        if (result == 0)
        {
            baseDirT.clear();
            break;
        }
        else if (result == ownPathLen && GetLastError() == ERROR_INSUFFICIENT_BUFFER)
            ownPathLen += MAX_PATH;
        else
            break;
    }
    size_t ownPathStrlen = _tcslen(baseDirT.data());
    for (size_t i = ownPathStrlen-1; i > 0; i--)
    {
        if (baseDirT[i] == TEXT('\\'))
        {
            baseDirT.resize(i + 1);
            baseDirT[i] = 0;
            ownPathStrlen = i;
            break;
        }
    }

    size_t outLen = 0;
    char *baseDirA = _TCHARToMultiByte(baseDirT.data(), outLen);
    baseDir.assign(baseDirA);
    _FreeCHAR(baseDirA);
    return baseDir;
}

int APIENTRY _tWinMain(HINSTANCE hInstance,
                     HINSTANCE hPrevInstance,
                     LPTSTR    lpCmdLine,
                     int       nCmdShow)
{
    std::string baseDir = getModuleBaseDir(hInstance);
    std::vector<char> argvBuf8;
    size_t totalArgvLen = 0;
    char **argv8 = new char*[__argc+1];
    for (int i = 0; i < __argc; i++)
    {
        size_t len16 = wcslen(__wargv[i]);
        if (len16 > INT_MAX) len16 = INT_MAX;
        size_t len8 = (size_t)WideCharToMultiByte(CP_UTF8, 0, __wargv[i], (int)len16, NULL, 0, NULL, NULL);
        size_t argvBufOffset = argvBuf8.size();
        argvBuf8.resize(argvBuf8.size() + len8 + 1);
        WideCharToMultiByte(CP_UTF8, 0, __wargv[i], (int)len16, &argvBuf8[argvBufOffset], (int)len8, NULL, NULL);
        argvBuf8[argvBufOffset + len8] = 0;
        argv8[i] = (char*)argvBufOffset;
    }
    for (int i = 0; i < __argc; i++)
    {
        argv8[i] = argvBuf8.data() + (size_t)argv8[i];
    }
    argv8[__argc] = nullptr;
    int ret = 0;
    if (HMODULE hUABEWin32 = GetModuleHandle(TEXT("UABE_Win32.dll")))
    {
        Win32AppContext appContext(hUABEWin32, baseDir);
        ret = appContext.Run(__argc, argv8);
    }
    delete[] argv8;
    return ret;
}

#else // Non-Windows platforms

#include <unistd.h>
#include <libgen.h>
#include <iostream>

#ifdef __APPLE__
#include <mach-o/dyld.h>
#include "../UABE_macOS/macOSAppContext.h"
#else
// For Linux and other Unix-like systems, we'll use a console version for now
#include "../UABE_macOS/macOSAppContext.h"
#endif

static std::string getExecutableBaseDir()
{
    std::string baseDir;
    char exePath[PATH_MAX];
    
#ifdef __APPLE__
    uint32_t size = sizeof(exePath);
    if (_NSGetExecutablePath(exePath, &size) == 0)
    {
        char* resolvedPath = realpath(exePath, nullptr);
        if (resolvedPath)
        {
            std::string path(resolvedPath);
            baseDir = std::filesystem::path(path).parent_path().string() + "/";
            free(resolvedPath);
        }
    }
#else
    ssize_t len = readlink("/proc/self/exe", exePath, sizeof(exePath) - 1);
    if (len != -1)
    {
        exePath[len] = '\0';
        std::string path(exePath);
        baseDir = std::filesystem::path(path).parent_path().string() + "/";
    }
#endif
    
    return baseDir;
}

int main(int argc, char** argv)
{
    std::string baseDir = getExecutableBaseDir();
    
    // Parse command line arguments to check for console mode
    bool useConsoleMode = false;
    for (int i = 1; i < argc; i++) {
        if (std::string(argv[i]) == "--console" || std::string(argv[i]) == "-c") {
            useConsoleMode = true;
            break;
        }
    }
    
#ifdef __APPLE__
    macOSAppContext appContext(baseDir, !useConsoleMode);
#else
    // For other Unix systems, GUI is not supported yet, use console mode
    macOSAppContext appContext(baseDir, false);
    if (!useConsoleMode) {
        std::cout << "Note: GUI mode not supported on this platform. Using console mode." << std::endl;
    }
#endif
    
    return appContext.Run(argc, argv);
}

#endif // _WIN32