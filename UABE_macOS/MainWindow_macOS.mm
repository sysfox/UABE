#import "MainWindow_macOS.h"
#import "macOSAppContext.h"
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

// Custom view controller for our main window
@interface UABEViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, NSOutlineViewDataSource, NSOutlineViewDelegate>
{
@private
    MainWindow_macOS* cppWindow;
    NSTableView* fileListTableView;
    NSOutlineView* assetTreeView;
    NSScrollView* fileListScrollView;
    NSScrollView* assetTreeScrollView;
    NSSplitView* splitView;
}

@property (nonatomic, assign) MainWindow_macOS* cppWindow;
@property (nonatomic, strong) NSTableView* fileListTableView;
@property (nonatomic, strong) NSOutlineView* assetTreeView;

- (void)setupViews;
- (void)refreshFileList;
- (void)refreshAssetTree;

@end

// Action handler for menu items
@interface UABEMenuActionHandler : NSObject
{
@private
    MainWindow_macOS* cppWindow;
}

@property (nonatomic, assign) MainWindow_macOS* cppWindow;

- (void)onFileOpenClicked:(id)sender;
- (void)onFileCloseClicked:(id)sender;
- (void)onEditPreferencesClicked:(id)sender;
- (void)onViewRefreshClicked:(id)sender;
- (void)onHelpAboutClicked:(id)sender;

@end

@implementation UABEMenuActionHandler

@synthesize cppWindow;

- (void)onFileOpenClicked:(id)sender {
    if (cppWindow) {
        cppWindow->onFileOpen();
    }
}

- (void)onFileCloseClicked:(id)sender {
    if (cppWindow) {
        cppWindow->onFileClose();
    }
}

- (void)onEditPreferencesClicked:(id)sender {
    if (cppWindow) {
        cppWindow->onEditPreferences();
    }
}

- (void)onViewRefreshClicked:(id)sender {
    if (cppWindow) {
        cppWindow->onViewRefresh();
    }
}

- (void)onHelpAboutClicked:(id)sender {
    if (cppWindow) {
        cppWindow->onHelpAbout();
    }
}

@end

@implementation UABEViewController

@synthesize cppWindow;
@synthesize fileListTableView;
@synthesize assetTreeView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)setupViews {
    // Create split view
    splitView = [[NSSplitView alloc] init];
    [splitView setDividerStyle:NSSplitViewDividerStyleThin];
    [splitView setVertical:NO]; // Horizontal split
    
    // Create file list table view
    fileListTableView = [[NSTableView alloc] init];
    [fileListTableView setDataSource:self];
    [fileListTableView setDelegate:self];
    [fileListTableView setHeaderView:nil];
    
    NSTableColumn *fileColumn = [[NSTableColumn alloc] initWithIdentifier:@"FileColumn"];
    [fileColumn setTitle:@"Files"];
    [fileColumn setWidth:300];
    [fileListTableView addTableColumn:fileColumn];
    
    fileListScrollView = [[NSScrollView alloc] init];
    [fileListScrollView setDocumentView:fileListTableView];
    [fileListScrollView setHasVerticalScroller:YES];
    
    // Create asset tree outline view
    assetTreeView = [[NSOutlineView alloc] init];
    [assetTreeView setDataSource:self];
    [assetTreeView setDelegate:self];
    [assetTreeView setHeaderView:nil];
    
    NSTableColumn *assetColumn = [[NSTableColumn alloc] initWithIdentifier:@"AssetColumn"];
    [assetColumn setTitle:@"Assets"];
    [assetColumn setWidth:300];
    [assetTreeView addTableColumn:assetColumn];
    [assetTreeView setOutlineTableColumn:assetColumn];
    
    assetTreeScrollView = [[NSScrollView alloc] init];
    [assetTreeScrollView setDocumentView:assetTreeView];
    [assetTreeScrollView setHasVerticalScroller:YES];
    
    // Add views to split view
    [splitView addSubview:fileListScrollView];
    [splitView addSubview:assetTreeScrollView];
    
    // Set up constraints
    [splitView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [fileListScrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [assetTreeScrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:splitView];
    
    // Set split view constraints to fill the view
    [NSLayoutConstraint activateConstraints:@[
        [splitView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [splitView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [splitView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [splitView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];
}

- (void)refreshFileList {
    [fileListTableView reloadData];
}

- (void)refreshAssetTree {
    [assetTreeView reloadData];
}

#pragma mark - NSTableViewDataSource & NSTableViewDelegate

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (tableView == fileListTableView) {
        // TODO: Get actual file count from app context
        return 0;
    }
    return 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableView == fileListTableView) {
        // TODO: Get actual file name from app context
        return @"Sample File";
    }
    return @"";
}

#pragma mark - NSOutlineViewDataSource & NSOutlineViewDelegate

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    // TODO: Get actual asset count from app context
    return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    // TODO: Get actual asset from app context
    return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    // TODO: Determine if asset has children
    return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    // TODO: Get actual asset name from app context
    return @"Sample Asset";
}

@end

#pragma mark - MainWindow_macOS Implementation

MainWindow_macOS::MainWindow_macOS(macOSAppContext* context)
    : appContext(context), window(nullptr), viewController(nullptr),
      fileListTableView(nullptr), assetTreeView(nullptr), menuBar(nullptr),
      actionHandler(nullptr), fileMenu(nullptr), editMenu(nullptr), viewMenu(nullptr)
{
}

MainWindow_macOS::~MainWindow_macOS()
{
    if (window) {
        [(__bridge NSWindow*)window close];
    }
    
    if (actionHandler) {
        CFBridgingRelease(actionHandler);
        actionHandler = nullptr;
    }
}

bool MainWindow_macOS::initialize()
{
    @autoreleasepool {
        // Create action handler
        actionHandler = (__bridge_retained void*)[[UABEMenuActionHandler alloc] init];
        UABEMenuActionHandler* handler = (__bridge UABEMenuActionHandler*)actionHandler;
        [handler setCppWindow:this];
        
        // Create the main window
        NSRect frame = NSMakeRect(100, 100, 800, 600);
        NSUInteger styleMask = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | 
                              NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable;
        
        window = (__bridge_retained void*)[[NSWindow alloc] initWithContentRect:frame
                                                                     styleMask:styleMask
                                                                       backing:NSBackingStoreBuffered
                                                                         defer:NO];
        
        NSWindow* nsWindow = (__bridge NSWindow*)window;
        [nsWindow setTitle:@"UABE - Unity Assets Bundle Extractor"];
        [nsWindow center];
        
        // Create and set up the view controller
        viewController = (__bridge_retained void*)[[UABEViewController alloc] init];
        UABEViewController* controller = (__bridge UABEViewController*)viewController;
        [controller setCppWindow:this];
        
        [nsWindow setContentViewController:controller];
        
        // Get references to the views
        fileListTableView = (__bridge void*)[controller fileListTableView];
        assetTreeView = (__bridge void*)[controller assetTreeView];
        
        // Set up menu bar
        setupMenuBar();
        
        return true;
    }
}

void MainWindow_macOS::setupMenuBar()
{
    @autoreleasepool {
        UABEMenuActionHandler* handler = (__bridge UABEMenuActionHandler*)actionHandler;
        NSMenu* mainMenu = [[NSMenu alloc] init];
        
        // Application Menu
        NSMenuItem* appMenuItem = [[NSMenuItem alloc] init];
        NSMenu* appMenu = [[NSMenu alloc] initWithTitle:@"UABE"];
        
        [appMenu addItem:[[NSMenuItem alloc] initWithTitle:@"About UABE" 
                                                    action:@selector(onHelpAboutClicked:)
                                             keyEquivalent:@""]];
        [[appMenu itemAtIndex:[appMenu numberOfItems]-1] setTarget:handler];
        
        [appMenu addItem:[NSMenuItem separatorItem]];
        [appMenu addItem:[[NSMenuItem alloc] initWithTitle:@"Preferences..." 
                                                    action:@selector(onEditPreferencesClicked:)
                                             keyEquivalent:@","]];
        [[appMenu itemAtIndex:[appMenu numberOfItems]-1] setTarget:handler];
        
        [appMenu addItem:[NSMenuItem separatorItem]];
        [appMenu addItem:[[NSMenuItem alloc] initWithTitle:@"Hide UABE" 
                                                    action:@selector(hide:)
                                             keyEquivalent:@"h"]];
        [appMenu addItem:[[NSMenuItem alloc] initWithTitle:@"Hide Others" 
                                                    action:@selector(hideOtherApplications:)
                                             keyEquivalent:@"h"]];
        [appMenu addItem:[[NSMenuItem alloc] initWithTitle:@"Show All" 
                                                    action:@selector(unhideAllApplications:)
                                             keyEquivalent:@""]];
        [appMenu addItem:[NSMenuItem separatorItem]];
        [appMenu addItem:[[NSMenuItem alloc] initWithTitle:@"Quit UABE" 
                                                    action:@selector(terminate:)
                                             keyEquivalent:@"q"]];
        
        [appMenuItem setSubmenu:appMenu];
        [mainMenu addItem:appMenuItem];
        
        // File Menu
        fileMenu = (__bridge_retained void*)[[NSMenuItem alloc] init];
        NSMenu* fileMenuSubmenu = [[NSMenu alloc] initWithTitle:@"File"];
        
        [fileMenuSubmenu addItem:[[NSMenuItem alloc] initWithTitle:@"Open..." 
                                                           action:@selector(onFileOpenClicked:)
                                                    keyEquivalent:@"o"]];
        [[fileMenuSubmenu itemAtIndex:[fileMenuSubmenu numberOfItems]-1] setTarget:handler];
        
        [fileMenuSubmenu addItem:[[NSMenuItem alloc] initWithTitle:@"Close" 
                                                           action:@selector(onFileCloseClicked:)
                                                    keyEquivalent:@"w"]];
        [[fileMenuSubmenu itemAtIndex:[fileMenuSubmenu numberOfItems]-1] setTarget:handler];
        
        [(__bridge NSMenuItem*)fileMenu setSubmenu:fileMenuSubmenu];
        [mainMenu addItem:(__bridge NSMenuItem*)fileMenu];
        
        // Edit Menu
        editMenu = (__bridge_retained void*)[[NSMenuItem alloc] init];
        NSMenu* editMenuSubmenu = [[NSMenu alloc] initWithTitle:@"Edit"];
        
        [editMenuSubmenu addItem:[[NSMenuItem alloc] initWithTitle:@"Cut" 
                                                           action:@selector(cut:)
                                                    keyEquivalent:@"x"]];
        [editMenuSubmenu addItem:[[NSMenuItem alloc] initWithTitle:@"Copy" 
                                                           action:@selector(copy:)
                                                    keyEquivalent:@"c"]];
        [editMenuSubmenu addItem:[[NSMenuItem alloc] initWithTitle:@"Paste" 
                                                           action:@selector(paste:)
                                                    keyEquivalent:@"v"]];
        
        [(__bridge NSMenuItem*)editMenu setSubmenu:editMenuSubmenu];
        [mainMenu addItem:(__bridge NSMenuItem*)editMenu];
        
        // View Menu
        viewMenu = (__bridge_retained void*)[[NSMenuItem alloc] init];
        NSMenu* viewMenuSubmenu = [[NSMenu alloc] initWithTitle:@"View"];
        
        [viewMenuSubmenu addItem:[[NSMenuItem alloc] initWithTitle:@"Refresh" 
                                                           action:@selector(onViewRefreshClicked:)
                                                    keyEquivalent:@"r"]];
        [[viewMenuSubmenu itemAtIndex:[viewMenuSubmenu numberOfItems]-1] setTarget:handler];
        
        [(__bridge NSMenuItem*)viewMenu setSubmenu:viewMenuSubmenu];
        [mainMenu addItem:(__bridge NSMenuItem*)viewMenu];
        
        // Set the main menu
        menuBar = (__bridge_retained void*)mainMenu;
        [NSApp setMainMenu:mainMenu];
    }
}

void MainWindow_macOS::show()
{
    if (window) {
        NSWindow* nsWindow = (__bridge NSWindow*)window;
        [nsWindow makeKeyAndOrderFront:nil];
    }
}

void MainWindow_macOS::hide()
{
    if (window) {
        NSWindow* nsWindow = (__bridge NSWindow*)window;
        [nsWindow orderOut:nil];
    }
}

void MainWindow_macOS::close()
{
    if (window) {
        NSWindow* nsWindow = (__bridge NSWindow*)window;
        [nsWindow close];
    }
}

void MainWindow_macOS::updateFileList()
{
    if (fileListTableView) {
        NSTableView* tableView = (__bridge NSTableView*)fileListTableView;
        [tableView reloadData];
    }
}

void MainWindow_macOS::updateAssetTree()
{
    if (assetTreeView) {
        NSOutlineView* outlineView = (__bridge NSOutlineView*)assetTreeView;
        [outlineView reloadData];
    }
}

bool MainWindow_macOS::showAssetBatchImportDialog(IAssetBatchImportDesc* pDesc, const std::string& basePath)
{
    @autoreleasepool {
        NSAlert* alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Batch Import"];
        [alert setInformativeText:[NSString stringWithFormat:@"Batch import dialog for path: %s", basePath.c_str()]];
        [alert addButtonWithTitle:@"Import"];
        [alert addButtonWithTitle:@"Cancel"];
        
        NSModalResponse response = [alert runModal];
        return (response == NSAlertFirstButtonReturn);
    }
}

std::string MainWindow_macOS::queryAssetExportLocation(const std::vector<AssetUtilDesc>& assets,
    const std::string& extension, const std::string& extensionFilter)
{
    @autoreleasepool {
        NSSavePanel* savePanel = [NSSavePanel savePanel];
        
        if (!extension.empty()) {
            [savePanel setAllowedFileTypes:@[[NSString stringWithUTF8String:extension.c_str()]]];
        }
        
        NSModalResponse response = [savePanel runModal];
        if (response == NSModalResponseOK) {
            NSURL* url = [savePanel URL];
            return std::string([[url path] UTF8String]);
        }
        
        return "";
    }
}

std::vector<std::string> MainWindow_macOS::queryAssetImportLocation(std::vector<AssetUtilDesc>& assets,
    const std::string& extension, const std::string& extensionRegex, const std::string& extensionFilter)
{
    @autoreleasepool {
        NSOpenPanel* openPanel = [NSOpenPanel openPanel];
        [openPanel setCanChooseFiles:YES];
        [openPanel setCanChooseDirectories:NO];
        [openPanel setAllowsMultipleSelection:YES];
        
        if (!extension.empty()) {
            [openPanel setAllowedFileTypes:@[[NSString stringWithUTF8String:extension.c_str()]]];
        }
        
        NSModalResponse response = [openPanel runModal];
        if (response == NSModalResponseOK) {
            std::vector<std::string> result;
            NSArray* urls = [openPanel URLs];
            
            for (NSURL* url in urls) {
                result.push_back(std::string([[url path] UTF8String]));
            }
            
            return result;
        }
        
        return {};
    }
}

// Menu action implementations (these would be called by the Objective-C runtime)
void MainWindow_macOS::onFileOpen()
{
    @autoreleasepool {
        NSOpenPanel* openPanel = [NSOpenPanel openPanel];
        [openPanel setCanChooseFiles:YES];
        [openPanel setCanChooseDirectories:NO];
        [openPanel setAllowsMultipleSelection:NO];
        
        NSModalResponse response = [openPanel runModal];
        if (response == NSModalResponseOK) {
            NSURL* url = [openPanel URL];
            std::string path = std::string([[url path] UTF8String]);
            
            // TODO: Use appContext to open the file
            NSLog(@"Opening file: %s", path.c_str());
        }
    }
}

void MainWindow_macOS::onFileClose()
{
    // TODO: Close current file
    NSLog(@"Closing file");
}

void MainWindow_macOS::onFileExit()
{
    [NSApp terminate:nil];
}

void MainWindow_macOS::onEditPreferences()
{
    // TODO: Show preferences dialog
    NSLog(@"Showing preferences");
}

void MainWindow_macOS::onViewRefresh()
{
    updateFileList();
    updateAssetTree();
    NSLog(@"Refreshing view");
}

void MainWindow_macOS::onHelpAbout()
{
    @autoreleasepool {
        NSAlert* alert = [[NSAlert alloc] init];
        [alert setMessageText:@"About UABE"];
        [alert setInformativeText:@"Unity Assets Bundle Extractor\nVersion 1.0\n\nmacOS Port"];
        [alert runModal];
    }
}