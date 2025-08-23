#pragma once
#include "api.h"
#include "AppContext.h"

#include <string>
#include <mutex>
#include <vector>

class MainWindow;

enum EmacOSAppContextMsg
{
    macOSAppContextMsg_COUNT = AppContextMsg_COUNT
};

class macOSAppContext : public AppContext
{
    std::string baseDir;
    
    size_t gcMemoryLimit;
    unsigned int gcMinAge;
    void LoadSettings();
    
    bool handlingMessages;
    std::mutex messageMutex;
    std::vector<std::pair<EAppContextMsg, void*>> messageQueue;
    bool messagePosted;
    
    void handleMessages();
    bool processMessage(EAppContextMsg message, void *args);
    
    std::shared_ptr<FileContextInfo> OnFileOpenAsBundle(std::shared_ptr<FileOpenTask> pTask, BundleFileContext *pContext, EBundleFileOpenStatus openStatus, unsigned int parentFileID, unsigned int directoryEntryIdx);
    std::shared_ptr<FileContextInfo> OnFileOpenAsAssets(std::shared_ptr<FileOpenTask> pTask, AssetsFileContext *pContext, EAssetsFileOpenStatus openStatus, unsigned int parentFileID, unsigned int directoryEntryIdx);
    std::shared_ptr<FileContextInfo> OnFileOpenAsResources(std::shared_ptr<FileOpenTask> pTask, ResourcesFileContext *pContext, unsigned int parentFileID, unsigned int directoryEntryIdx);
    std::shared_ptr<FileContextInfo> OnFileOpenAsGeneric(std::shared_ptr<FileOpenTask> pTask, GenericFileContext *pContext, unsigned int parentFileID, unsigned int directoryEntryIdx);
    void OnFileOpenFail(std::shared_ptr<FileOpenTask> pTask, std::string &logText);
    
public:
    UABE_macOS_API void OnUpdateContainers(AssetsFileContextInfo *info);
    UABE_macOS_API void OnUpdateDependencies(AssetsFileContextInfo *info, size_t from, size_t to);
    
protected:
    void OnDecompressBundle(BundleFileContextInfo::DecompressTask *pTask, TaskResult result);
    void OnChangeAsset(AssetsFileContextInfo *pFile, pathid_t pathID, bool wasRemoved);
    void OnChangeBundleEntry(BundleFileContextInfo *pFile, size_t index);
    
    void RemoveContextInfo(FileContextInfo *info);
    
public:
    UABE_macOS_API void signalMainThread(EAppContextMsg message, void *args);
    
    // Process memory threshold that triggers cache 'garbage collection'
    inline size_t getGCMemoryLimit() { return gcMemoryLimit; }
    // Minimum age of a resource to be eligible for 'garbage collection'
    inline unsigned int getGCMinAge() { return gcMinAge; }
    inline std::string getBaseDir() { return baseDir; }
    
    UABE_macOS_API bool ShowAssetBatchImportDialog(IAssetBatchImportDesc* pDesc, std::string basePath);
    
    // Asks the user to provide an export file or directory path
    UABE_macOS_API std::string QueryAssetExportLocation(const std::vector<struct AssetUtilDesc>& assets,
        const std::string &extension, const std::string &extensionFilter);
    
    // Asks the user to provide an import file or directory path
    UABE_macOS_API std::vector<std::string> QueryAssetImportLocation(std::vector<AssetUtilDesc>& assets,
        std::string extension, std::string extensionRegex, std::string extensionFilter);
    
    UABE_macOS_API macOSAppContext(const std::string &baseDir);
    UABE_macOS_API ~macOSAppContext();
    
    UABE_macOS_API int Run(size_t argc, char **argv);
};