#include "macOSAppContext.h"
#include "MainWindow_macOS.h"
#include <assert.h>
#include <iostream>
#include <filesystem>
#include <thread>
#include <chrono>

#ifdef __APPLE__
#include <Cocoa/Cocoa.h>
#endif

macOSAppContext::macOSAppContext(const std::string &baseDir, bool useGUI)
    : baseDir(baseDir), useGUI(useGUI), handlingMessages(false), messagePosted(false),
      gcMemoryLimit(0), gcMinAge(0)
{
    LoadSettings();
    
    // Initialize GUI if requested and we're on macOS
#ifdef __APPLE__
    if (useGUI) {
        mainWindow = std::make_unique<MainWindow_macOS>(this);
    }
#else
    if (useGUI) {
        std::cout << "Warning: GUI mode requested but not supported on this platform. Using console mode." << std::endl;
        this->useGUI = false;
    }
#endif
}

macOSAppContext::~macOSAppContext()
{
}

void macOSAppContext::signalMainThread(EAppContextMsg message, void *args)
{
    std::lock_guard<std::mutex> lock(messageMutex);
    messageQueue.push_back(std::make_pair(message, args));
    
    if (!messagePosted)
    {
        messagePosted = true;
        // For now, we'll handle messages synchronously
        // In a full GUI implementation, this would post to the main event loop
    }
}

void macOSAppContext::handleMessages()
{
    std::lock_guard<std::mutex> lock(messageMutex);
    handlingMessages = true;
    
    while (!messageQueue.empty())
    {
        auto msg = messageQueue.front();
        messageQueue.erase(messageQueue.begin());
        
        processMessage(msg.first, msg.second);
    }
    
    handlingMessages = false;
    messagePosted = false;
}

bool macOSAppContext::processMessage(EAppContextMsg message, void *args)
{
    return AppContext::processMessage(message, args);
}

std::shared_ptr<FileContextInfo> macOSAppContext::OnFileOpenAsBundle(std::shared_ptr<FileOpenTask> pTask, 
    BundleFileContext *pContext, EBundleFileOpenStatus openStatus, unsigned int parentFileID, unsigned int directoryEntryIdx)
{
    return AppContext::OnFileOpenAsBundle(pTask, pContext, openStatus, parentFileID, directoryEntryIdx);
}

std::shared_ptr<FileContextInfo> macOSAppContext::OnFileOpenAsAssets(std::shared_ptr<FileOpenTask> pTask, 
    AssetsFileContext *pContext, EAssetsFileOpenStatus openStatus, unsigned int parentFileID, unsigned int directoryEntryIdx)
{
    return AppContext::OnFileOpenAsAssets(pTask, pContext, openStatus, parentFileID, directoryEntryIdx);
}

std::shared_ptr<FileContextInfo> macOSAppContext::OnFileOpenAsResources(std::shared_ptr<FileOpenTask> pTask, 
    ResourcesFileContext *pContext, unsigned int parentFileID, unsigned int directoryEntryIdx)
{
    return AppContext::OnFileOpenAsResources(pTask, pContext, parentFileID, directoryEntryIdx);
}

std::shared_ptr<FileContextInfo> macOSAppContext::OnFileOpenAsGeneric(std::shared_ptr<FileOpenTask> pTask, 
    GenericFileContext *pContext, unsigned int parentFileID, unsigned int directoryEntryIdx)
{
    return AppContext::OnFileOpenAsGeneric(pTask, pContext, parentFileID, directoryEntryIdx);
}

void macOSAppContext::OnFileOpenFail(std::shared_ptr<FileOpenTask> pTask, std::string &logText)
{
    std::cerr << "Failed to open file: " << logText << std::endl;
    AppContext::OnFileOpenFail(pTask, logText);
}

void macOSAppContext::OnUpdateContainers(AssetsFileContextInfo *info)
{
    // For now, just call the base implementation
    AppContext::OnUpdateContainers(info);
}

void macOSAppContext::OnUpdateDependencies(AssetsFileContextInfo *info, size_t from, size_t to)
{
    // For now, just call the base implementation
    AppContext::OnUpdateDependencies(info, from, to);
}

void macOSAppContext::OnDecompressBundle(BundleFileContextInfo::DecompressTask *pTask, TaskResult result)
{
    // Handle bundle decompression result
    if (result >= 0)
        std::cout << "Bundle decompressed successfully" << std::endl;
    else
        std::cerr << "Bundle decompression failed" << std::endl;
}

void macOSAppContext::RemoveContextInfo(FileContextInfo *info)
{
    AppContext::RemoveContextInfo(info);
}

void macOSAppContext::LoadSettings()
{
    gcMinAge = 15;
    gcMemoryLimit = 2 * 1024 * 1024 * 1024ULL; // 2GiB default
    autoDetectDependencies = true;
    // TODO: Load from settings file
}

void macOSAppContext::OnChangeAsset(AssetsFileContextInfo *pFile, pathid_t pathID, bool wasRemoved)
{
    // Handle asset changes
    AppContext::OnChangeAsset(pFile, pathID, wasRemoved);
}

void macOSAppContext::OnChangeBundleEntry(BundleFileContextInfo *pFile, size_t index)
{
    // Handle bundle entry changes
    AppContext::OnChangeBundleEntry(pFile, index);
}

bool macOSAppContext::ShowAssetBatchImportDialog(IAssetBatchImportDesc* pDesc, std::string basePath)
{
    if (useGUI && mainWindow) {
        return mainWindow->showAssetBatchImportDialog(pDesc, basePath);
    } else {
        // For console mode, return false to indicate dialog not shown
        std::cout << "Batch import dialog requested (console mode)" << std::endl;
        return false;
    }
}

std::string macOSAppContext::QueryAssetExportLocation(const std::vector<struct AssetUtilDesc>& assets,
    const std::string &extension, const std::string &extensionFilter)
{
    if (useGUI && mainWindow) {
        return mainWindow->queryAssetExportLocation(assets, extension, extensionFilter);
    } else {
        // For console mode, return empty string to indicate cancellation
        std::cout << "Export location query (console mode)" << std::endl;
        return "";
    }
}

std::vector<std::string> macOSAppContext::QueryAssetImportLocation(std::vector<AssetUtilDesc>& assets,
    std::string extension, std::string extensionRegex, std::string extensionFilter)
{
    if (useGUI && mainWindow) {
        return mainWindow->queryAssetImportLocation(assets, extension, extensionRegex, extensionFilter);
    } else {
        // For console mode, return empty vector to indicate cancellation
        std::cout << "Import location query (console mode)" << std::endl;
        return {};
    }
}

int macOSAppContext::Run(size_t argc, char **argv)
{
    std::cout << "macOS UABE Context starting..." << std::endl;
    
    // Load class database package
    std::string errorMessage;
    if (!LoadClassDatabasePackage(baseDir, errorMessage))
    {
        std::cerr << "Failed to load class database: " << errorMessage << std::endl;
        return -1;
    }
    
    // Set up task manager
    taskManager.setMaxThreads(0); // Use default number of threads
    
    std::cout << "macOS UABE Context initialized. Base directory: " << baseDir << std::endl;
    
    if (useGUI) {
#ifdef __APPLE__
        // Initialize Cocoa application
        @autoreleasepool {
            [NSApplication sharedApplication];
            [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
            
            // Initialize main window
            if (mainWindow && mainWindow->initialize()) {
                mainWindow->show();
                
                // Run the main event loop
                std::cout << "Starting GUI mode..." << std::endl;
                [NSApp run];
            } else {
                std::cerr << "Failed to initialize main window" << std::endl;
                return -1;
            }
        }
#endif
    } else {
        // Console mode - basic message loop
        std::cout << "Running in console mode..." << std::endl;
        
        while (true)
        {
            handleMessages();
            
            // For demo purposes, exit after a short time
            // In a real implementation, this would be the main event loop
            static int counter = 0;
            if (++counter > 10) break;
            
            std::this_thread::sleep_for(std::chrono::milliseconds(100));
        }
    }
    
    std::cout << "macOS UABE Context shutting down..." << std::endl;
    return 0;
}