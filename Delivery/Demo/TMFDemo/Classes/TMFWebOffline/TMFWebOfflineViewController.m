//
//  TMFWebOfflineViewController.m
//  TMFDemo
//
//  Created by hauzhong on 2019/4/12.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "TMFWebOfflineViewController.h"
#import "TMFDemoConfigurations.h"

#import "TMFWebOfflineService.h"
#import "TMFWebOfflineWKWebViewController.h"
#import "NSString+Localize.h"

#define CHECK_SINGLE     [@"check and download web offline package(single BID)" localizedString]
#define CHECK_MULTI      [@"check and download web offline package(multiple BIDs)" localizedString]
#define CHECK_ALL        [@"check and download web offline package(all)" localizedString]
#define CHECK_UPDATE     [@"check online web offline package update info" localizedString]
#define CREATE_LOCAL     [@"create local web offline packages list" localizedString]
#define BATCH_DOWNLOAD   [@"batch download" localizedString]
#define CANCEL_DOWNLOAD  [@"cancel download" localizedString]
#define LOAD_LOCAL       [@"load local package" localizedString]
#define TEST_PACKAGE     [@"test package in WKWebView" localizedString]
#define REMOVE_PACKAGE   [@"remove local package cache" localizedString]
#define REMOVE_ALL       [@"remove all local packages cache" localizedString]
#define CHECK_VERSION    [@"check loaded package version" localizedString]
#define TEST_CLEAR       [@"test clear cache-home" localizedString]

/**
 @brief 离线包操作demo
 */
@interface TMFWebOfflineViewController () <QMUIAlertControllerDelegate> {
    dispatch_queue_t _queue;
}
@property (nonatomic, strong) NSString *BID;
@property (nonatomic, strong) NSMutableArray<TMFWebOfflinePackageInfo *> *downloadPackageInfos;
@end

@implementation TMFWebOfflineViewController

- (void)initDataSource {
    [super initDataSource];
    self.dataSource = @[CHECK_SINGLE,
                        CHECK_MULTI,
                        CHECK_ALL,
                        CHECK_UPDATE,
                        CREATE_LOCAL,
                        BATCH_DOWNLOAD,
                        CANCEL_DOWNLOAD,
                        LOAD_LOCAL,
                        TEST_PACKAGE,
                        REMOVE_PACKAGE,
                        REMOVE_ALL,
                        CHECK_VERSION,
                        TEST_CLEAR
                        ];
    
    _queue = dispatch_queue_create("WebOfline_Demo", DISPATCH_QUEUE_SERIAL);
    self.downloadPackageInfos = [NSMutableArray array];
    self.BID = WEB_OFFLINE_TEST_BID;
}

- (void)didSelectCellWithTitle:(NSString *)title {
    if ([title isEqualToString:CHECK_SINGLE]) {
        [self updateAndDownloadOnePackage];
    } else if ([title isEqualToString:CHECK_MULTI]) {
        [self updateAndDownloadMultiplePackages];
    } else if ([title isEqualToString:CHECK_ALL]) {
        [self updateAndDownloadAllAvailablePackages];
    } else if ([title isEqualToString:LOAD_LOCAL]) {
        [self loadPackage];
    } else if ([title isEqualToString:TEST_PACKAGE]) {
        [self openWKWebview];
    } else if ([title isEqualToString:REMOVE_PACKAGE]) {
        [self removLocalPackage];
    } else if ([title isEqualToString:CHECK_VERSION]) {
        [self localVersion];
    } else if ([title isEqualToString:REMOVE_ALL]) {
        [self removLocalPackages];
    } else if ([title isEqualToString:CHECK_UPDATE]) {
        [self checkUpdtePackageInfos];
    } else if ([title isEqualToString:CREATE_LOCAL]) {
        [self createLocalPackageInfos];
    } else if ([title isEqualToString:BATCH_DOWNLOAD]) {
        [self batchDownload];
    } else if ([title isEqualToString:CANCEL_DOWNLOAD]) {
        [self cancelBatchDownload];
    } else if ([title isEqualToString:TEST_CLEAR
               ]){
        [self testClearWebOfflineCache];
    }
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = [NSString stringWithFormat:@"%@-TMFWebOffline",[@"web offline" localizedString]];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithTitle:[@"change BID" localizedString] target:self action:@selector(handleExitEvent)];
    AddAccessibilityLabel(self.navigationItem.rightBarButtonItem, [@"change BID" localizedString]);
}

- (void)handleExitEvent {
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:[@"done" localizedString] style:QMUIAlertActionStyleCancel handler:NULL];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:[@"BID has been changed" localizedString] message:nil
                                                                          preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController setDelegate:self];
    [alertController addAction:action1];
    [alertController addTextFieldWithConfigurationHandler:^(QMUITextField *textField) {

    }];
    [alertController showWithAnimated:YES];
}

- (BOOL)shouldHideAlertController:(QMUIAlertController *)alertController {
    QMUITextField *textField = [alertController.textFields firstObject];
    if (textField.text.length > 0) {
        self.BID = textField.text;
    }
    return YES;
}

- (void)didHideAlertController:(QMUIAlertController *)alertController {
}

- (void)didShowAlertController:(QMUIAlertController *)alertController {
}

- (void)willHideAlertController:(QMUIAlertController *)alertController {
}

- (void)willShowAlertController:(QMUIAlertController *)alertController {
}

#pragma mark - Actions

- (void)updateAndDownloadOnePackage {
    // Note: 检查离线包是否有更新，存在更新同时下载离线包
    QMUITips *tips = [QMUITips showLoadingInView:self.view hideAfterDelay:15];

    TMFWebOfflineServiceOptions *options = [TMFWebOfflineServiceOptions options];
    options.ignoresFrequency = YES; /* !!!仅demo演示忽略频控策略。如果终端需要控制频率，不要设置options!!! */
    [TMFWebOfflineService checkAndUpdateWithBID:self.BID options:options completionHandler:^(BOOL isUpdated, NSError *_Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [tips hideAnimated:YES];
            NSString *title = nil;
            NSString *message = nil;
            if (error) {
                title = [@"package update failed" localizedString];
                message = [NSString stringWithFormat:[@"BID: %@\nError info: %@" localizedString], self.BID, error];
            } else if (isUpdated) {
                title = [@"package update success" localizedString];
                message = [NSString stringWithFormat:[@"update package BID: %@" localizedString], self.BID];
            } else {
                message = [@"package has no update info" localizedString];
            }
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:title message:message
                                                                                  preferredStyle:QMUIAlertControllerStyleAlert];
            QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:@"OK" style:QMUIAlertActionStyleCancel handler:NULL];
            [alertController addAction:action];
            [alertController showWithAnimated:YES];
        });
    }];
}

- (void)updateAndDownloadMultiplePackages {
    // Note: 批量检查离线包是否有更新，有更新则批量下载离线包(多个BID)
    QMUITips *tips = [QMUITips showLoadingInView:self.view hideAfterDelay:15];
    NSMutableArray *errors = [NSMutableArray array];
    TMFWebOfflineServiceOptions *options = [TMFWebOfflineServiceOptions options];
    options.ignoresFrequency = YES; /* !!!仅demo演示忽略频控策略。如果终端需要控制频率，不要设置options!!! */
    [TMFWebOfflineService checkAndUpdateWithBIDs:@[self.BID, WEB_OFFLINE_TEST_COMM_BID]
                                         options:options
                                 progressHandler:^(NSString * _Nonnull BID, NSError * _Nullable error) {
        if (error) {
            [errors addObject:[NSString stringWithFormat:@"BID: %@\n error Msg: %@", BID, error]];
        }
    } completionHandler:^(NSArray<NSString *> *_Nonnull updatedBIDs) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [tips hideAnimated:YES];
            NSString *title = nil;
            NSString *message = nil;
            if (updatedBIDs.count > 0) {
                title = @"Offline package updated successfully";
                [errors addObject: [NSString stringWithFormat:@"Updated BIDs: %@", [updatedBIDs componentsJoinedByString:@", "]]];
            } else {
                title = @"Offline package is not updated or failed";
            }
            message = [errors componentsJoinedByString:@";\n "];
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:title message:message
                                                                                  preferredStyle:QMUIAlertControllerStyleAlert];
            QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:@"OK" style:QMUIAlertActionStyleCancel handler:NULL];
            [alertController addAction:action];
            [alertController showWithAnimated:YES];
        });
    }];
}

- (void)updateAndDownloadAllAvailablePackages {
    // Note: 全量预加载离线包
    // Note: 检查网络可更新的全部的离线包，同时下载更新的离线包
    QMUITips *tips = [QMUITips showLoadingInView:self.view hideAfterDelay:15];
    NSMutableArray *errors = [NSMutableArray array];
    
    TMFWebOfflineServiceOptions *options = [TMFWebOfflineServiceOptions options];
    [TMFWebOfflineService checkAndUpdateAllAvailablePackagesWithOptions:options
                                                        progressHandler:^(NSString * _Nonnull BID, NSError * _Nullable error) {
        if (error) {
            [errors addObject:[NSString stringWithFormat:@"BID: %@\n error Msg: %@", BID, error]];
        }
    } completionHandler:^(NSArray<NSString *> * _Nonnull updatedBIDs) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [tips hideAnimated:YES];
            NSString *title = nil;
            NSString *message = nil;
            if (updatedBIDs.count > 0) {
                title = @"Offline package updated successfully";
                [errors addObject: [NSString stringWithFormat:@"Updated BIDs: %@", [updatedBIDs componentsJoinedByString:@", "]]];
            } else {
                title = @"Offline package is not updated or failed";
            }
            message = [errors componentsJoinedByString:@";\n "];
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:title message:message
                                                                                  preferredStyle:QMUIAlertControllerStyleAlert];
            QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:@"OK" style:QMUIAlertActionStyleCancel handler:NULL];
            [alertController addAction:action];
            [alertController showWithAnimated:YES];
        });
    }];
}

- (void)loadPackage {
    // Note: 加载已经下载到本地的离线包
    [TMFWebOfflineService uncompressPackagesIfNeeded];

    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:[@"load local package complete" localizedString] message:nil
                                                                          preferredStyle:QMUIAlertControllerStyleActionSheet];
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"OK" style:QMUIAlertActionStyleCancel handler:NULL];
    [alertController addAction:action1];
    [alertController showWithAnimated:YES];
}

- (void)openWKWebview {
    // Note: 跳转到WebView界面，在此界面内测试离线模块与urlcache和webview的结合处理
    NSString *BIDs = [NSString stringWithFormat:@"%@+%@", WEB_OFFLINE_TEST_COMM_BID, self.BID];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:WEB_OFFLINE_TEST_URL_FORMAT, BIDs]];
    TMFWebOfflineWKWebViewController *viewController = [[TMFWebOfflineWKWebViewController alloc] initWithURL:URL];
    viewController.title = [@"test package in WKWebView" localizedString];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)localVersion {
    // Note: 查看离线包的本地版本号
    int v = [TMFWebOfflineService localVersionForBID:self.BID];
    NSString *version = [NSString stringWithFormat:@"%d", v];
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"OK" style:QMUIAlertActionStyleCancel handler:NULL];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:[@"version: " localizedString] message:version
                                                                          preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:action1];
    [alertController showWithAnimated:YES];
}

- (void)removLocalPackage {
    // Note: 移除本地离线包
    [TMFWebOfflineService removeLocalPackageWithBID:self.BID];

    NSString *message = [NSString stringWithFormat:[@"local package (%@) has been removed" localizedString], self.BID];
    [QMUITips showInfo:message detailText:nil inView:self.view hideAfterDelay:2];
}

- (void)removLocalPackages {
    // Note: 批量移除本地离线包
    [TMFWebOfflineService removeAllLocalPackage];

    NSString *message = [@"all local packages have been removed" localizedString];
    [QMUITips showInfo:message detailText:nil inView:self.view hideAfterDelay:2];
}

- (void)checkUpdtePackageInfos {
    // 使用 `-checkPackageInfosWithBIDs:options:completionHandler:` 检查离线包更新后，
    // 可调用 `-downloadPackageWithInfo:options:completionHandler:` 自行选择需要下载的离线包
    TMFWebOfflineServiceOptions *options = [TMFWebOfflineServiceOptions options];
    options.ignoresFrequency = YES; /* !!!仅demo演示忽略频控策略。如果终端需要控制频率，不要设置options!!! */
    [TMFWebOfflineService checkPackageInfosWithBIDs:@[self.BID] options:options completionHandler:^(
        NSArray<TMFWebOfflinePackageInfo *> *_Nonnull packageInfos, NSError *_Nullable error) {
        NSMutableArray<NSString *> *updatedBIDs = [NSMutableArray array];
        if (error || packageInfos.count == 0) {
            NSLog(@"[WebOffline]: check error: %@, update package count: %ld", error, (long)packageInfos.count);
        } else {
            [self.downloadPackageInfos removeAllObjects];
            for (TMFWebOfflinePackageInfo *packageInfo in packageInfos) {
                [self.downloadPackageInfos addObject:packageInfo];
                [updatedBIDs addObject:packageInfo.BID];
            }
        }

        NSLog(@"[WebOffline]: updatedBIDs: %@", [updatedBIDs componentsJoinedByString:@", "]);

        NSString *title = nil;
        NSString *message = nil;
        if (updatedBIDs.count > 0) {
            title = [@"package update info" localizedString];
            message = [NSString stringWithFormat:[@"packages BIDs: %@, click [Batch download] to download" localizedString], [updatedBIDs componentsJoinedByString:@", "]];
        } else {
            message = [@"package has no update info" localizedString];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:title message:message
                                                                                  preferredStyle:QMUIAlertControllerStyleAlert];
            QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:@"OK" style:QMUIAlertActionStyleCancel handler:NULL];
            [alertController addAction:action];
            [alertController showWithAnimated:YES];
        });
    }];
}

- (void)testClearWebOfflineCache{
    /**
     @brief 测试清理某个bid的缓存
     */
    [TMFWebOfflineService clearPackageCacheWithBID:@"home"];
}

- (void)createLocalPackageInfos {
    // Note: 仅为演示批量生成离线包下载的文件信息，这种方式下只能下载未经过加密的离线包!!!
    // Note: 如果离线包经过加密的话，`TMFWebOfflinePackageInfo` 不应单独创建，建议通过 `-checkPackageInfosWithBIDs:completionHandler:`
    // 来获取，详见本Demo的 `-checkUpdtePackageInfos` 用法
    [self.downloadPackageInfos removeAllObjects];
    NSArray *BIDs =
        @[@"bid1", @"bid2", @"bid3", @"bid4", @"bid5", @"bid6", @"bid7", @"bid8", @"bid9", @"bid10", @"bid1", @"bid2", @"bid3", @"bid4", @"bid5"];
    for (NSString *BID in BIDs) {
        TMFWebOfflinePackageInfo *packageInfo = [[TMFWebOfflinePackageInfo alloc] init];
        packageInfo.BID = BID;
        packageInfo.URL = @"http://129.204.11.154:30010/cdn/ios_fallback/602166/bsdiff_base_602166.zip";
        packageInfo.MD5 = @"8a93751e29f64e008922267e092f62a2";
        packageInfo.updateType = TMFWebOfflinePackageUpdateTypeNormal;
        [self.downloadPackageInfos addObject:packageInfo];
    }

    NSString *title = [@"package update info" localizedString];
    NSString *message = [NSString stringWithFormat:[@"local packages BIDs: %@, click [Batch download] to download" localizedString], [BIDs componentsJoinedByString:@", "]];
    dispatch_async(dispatch_get_main_queue(), ^{
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:title message:message
                                                                              preferredStyle:QMUIAlertControllerStyleAlert];
        QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:@"OK" style:QMUIAlertActionStyleCancel handler:NULL];
        [alertController addAction:action];
        [alertController showWithAnimated:YES];
    });
}

- (void)batchDownload {
    // Note: 这里仅为演示的离线包批量下载的文件信息，按照这种配置只能下载未经过加密的离线包!!!
    // Note: 如果离线包经过加密的话，`TMFWebOfflinePackageInfo` 不应单独创建，建议通过 `-checkPackageInfosWithBIDs:completionHandler:`
    // 来获取，详见本Demo的 `-checkUpdtePackageInfos` 用法
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    __block NSUInteger updatedSignals = self.downloadPackageInfos.count;
    NSMutableArray<NSString *> *updatedBIDs = [NSMutableArray array];
    TMFWebOfflineServiceOptions *options = [TMFWebOfflineServiceOptions options];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (TMFWebOfflinePackageInfo *packageInfo in self.downloadPackageInfos) {
            [TMFWebOfflineService downloadPackageWithInfo:packageInfo options:options completionHandler:^(NSError *_Nullable error) {
                NSLog(@"[WebOffline]: download error: %@", error);
                if (!error) {
                    [updatedBIDs addObject:packageInfo.BID];
                }

                updatedSignals--;
                if (updatedSignals == 0) {
                    dispatch_semaphore_signal(semaphore);
                }
            }];
            NSLog(@"[WebOffline]: addTask");
        }

        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        NSLog(@"[WebOffline]: updatedBIDs: %@", [updatedBIDs componentsJoinedByString:@", "]);

        NSString *title = [@"batch download success" localizedString];
        NSString *message = [NSString stringWithFormat:[@"download success packages BIDs: %@" localizedString], [updatedBIDs componentsJoinedByString:@", "]];
        dispatch_async(dispatch_get_main_queue(), ^{
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:title message:message
                                                                                  preferredStyle:QMUIAlertControllerStyleAlert];
            QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:@"OK" style:QMUIAlertActionStyleCancel handler:NULL];
            [alertController addAction:action];
            [alertController showWithAnimated:YES];
        });
    });
}

- (void)cancelBatchDownload {
    for (TMFWebOfflinePackageInfo *packageInfo in self.downloadPackageInfos) {
        [TMFWebOfflineService cancelDownloadPackageWithInfo:packageInfo];
    }
    NSLog(@"[WebOffline]: cancel all Download tasks");
}
@end
