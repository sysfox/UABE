#pragma once
#include "api.h"
#include <string>
#include <vector>
#include <memory>

#ifdef __OBJC__
@class NSWindow;
@class NSViewController;
@class NSTableView;
@class NSOutlineView;
@class NSMenu;
@class NSMenuItem;
#else
typedef void NSWindow;
typedef void NSViewController;
typedef void NSTableView;
typedef void NSOutlineView;
typedef void NSMenu;
typedef void NSMenuItem;
#endif

// Forward declarations
class macOSAppContext;
class FileContextInfo;
struct AssetUtilDesc;
class IAssetBatchImportDesc;

class MainWindow_macOS
{
private:
    macOSAppContext* appContext;
    NSWindow* window;
    NSViewController* viewController;
    NSTableView* fileListTableView;
    NSOutlineView* assetTreeView;
    NSMenu* menuBar;
    void* actionHandler; // UABEMenuActionHandler*
    
    // Menu items
    NSMenuItem* fileMenu;
    NSMenuItem* editMenu;
    NSMenuItem* viewMenu;
    
    void setupMenuBar();
    void setupMainWindow();
    void setupFileListView();
    void setupAssetTreeView();
    
public:
    UABE_macOS_API MainWindow_macOS(macOSAppContext* context);
    UABE_macOS_API ~MainWindow_macOS();
    
    // Window management
    UABE_macOS_API bool initialize();
    UABE_macOS_API void show();
    UABE_macOS_API void hide();
    UABE_macOS_API void close();
    
    // File operations
    UABE_macOS_API void updateFileList();
    UABE_macOS_API void updateAssetTree();
    
    // Dialog operations
    UABE_macOS_API bool showAssetBatchImportDialog(IAssetBatchImportDesc* pDesc, const std::string& basePath);
    UABE_macOS_API std::string queryAssetExportLocation(const std::vector<AssetUtilDesc>& assets,
        const std::string& extension, const std::string& extensionFilter);
    UABE_macOS_API std::vector<std::string> queryAssetImportLocation(std::vector<AssetUtilDesc>& assets,
        const std::string& extension, const std::string& extensionRegex, const std::string& extensionFilter);
    
    // Menu actions
    UABE_macOS_API void onFileOpen();
    UABE_macOS_API void onFileClose();
    UABE_macOS_API void onFileExit();
    UABE_macOS_API void onEditPreferences();
    UABE_macOS_API void onViewRefresh();
    UABE_macOS_API void onHelpAbout();
    
    // Accessors
    NSWindow* getWindow() const { return window; }
    macOSAppContext* getAppContext() const { return appContext; }
};