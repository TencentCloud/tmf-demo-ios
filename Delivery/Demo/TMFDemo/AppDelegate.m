//
//  AppDelegate.m
//  TMFDemo
//
//  Created by klaudz on 5/4/2019.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "AppDelegate.h"

#import "TMFBase.h"

// TMFShark
#import "TMFSharkCenterConfiguration.h"
#import "TMFSharkCenter+Profile.h"
#import "TMFSharkCenter.h"
#import "TMFSharkDemoUserConfiguration.h"

// CloudInstruction
#import "TMFInstructionCenter.h"
#import "TMFInstructionCenter+Iteration.h"
#import "TMFPushGo.h"

// QMUIKit
#import <QMUIKit/QMUIKit.h>
#import "QDCommonUI.h"
#import "QDUIHelper.h"
#import "QDThemeManager.h"

// TMFWebOffline
#import "TMFWebOfflineService.h"

// TMFPush
#import "TMFPush.h"
#import "TMFPush+Logger.h"

// Distribution
#import "TMFDistribution.h"


@interface AppDelegate () <TMFPushDelegate>
@property (nonatomic, strong)NSMutableDictionary *configValue;
@property (nonatomic, copy)NSString *configName;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self prepareEverything];
    return YES;
}

- (void)prepareEverything {
    [self prepareBase];
    [self preparePushGo];
    [self prepareDistribution];
    [self prepareWebOffline];
    [self prepareQMUI];
    [self preparePush];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    // 自动检查和更新离线包
    [self checkUpdateWebOfflineAutomatically];
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wmismatched-parameter-types"
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(nonnull void (^)(void))completionHandler
#pragma clang diagnostic pop
{
    NSLog(@"[TMFPush] did handle action for remote notification, userInfo: %@", userInfo);
    for (NSString *key in userInfo) {
        id value = userInfo[key];
        NSLog(@"[TMFPush] key: %@, value: %@", key, value);
    }
    
    completionHandler();
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wmismatched-parameter-types"
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(nonnull void (^)(void))completionHandler
#pragma clang diagnostic pop
{
    NSLog(@"[TMFPush] did handle action for remote notification, userInfo: %@, responseInfo: %@", userInfo, responseInfo);
    for (NSString *key in userInfo) {
        id value = userInfo[key];
        NSLog(@"[TMFPush] key: %@, value: %@", key, value);
    }
    
    completionHandler();
}
#pragma mark - Base
#define USE_JSON_CONFIG 1
- (void)prepareBase{
    [TMFBaseCore setAllowBaseCoreLogFilter:NO];
    [TMFSharkCenterConfiguration setLogLevels:1];
    [TMFInstructionCenter setLogLevels:TMFBaseCoreLogLevelAll];
    [TMFInstructionCenter setApiVersion:TMFInstructionCenterApiVersionPushGo];
    [TMFServerManager setLogLevels:TMFBaseCoreLogLevelAll];
    
    NSString *sanboxConfigPath = [TMFSharkEnvironmentConfiguration configFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:sanboxConfigPath]) {
        NSLog(@"‼️使用沙盒 Document\Environment 目录下的配置文件");
        [[TMFServerManager shareServerManagerWithConfigPath:sanboxConfigPath] activate];
    } else {
        NSLog(@"‼️使用 Project 的配置文件");
        [TMFServerManager start];
    }
    [[TMFPushGoCenter shareCenter] performSelectorOnMainThread:@selector(activate) withObject:nil waitUntilDone:NO];
    
    NSLog(@"GUID: %@", [TMFSharkCenter masterCenter].GUID);
    NSLog(@"%@", [TMFServerManager shareServerManager].workSpace);
}

#pragma mark - QMUIKit
- (void)prepareQMUI {
    // QMUIConsole 默认只在 DEBUG 下会显示，作为 Demo，改为不管什么环境都允许显示
    [QMUIConsole sharedInstance].canShow = YES;
    // QD自定义的全局样式渲染
    [QDCommonUI renderGlobalAppearances];
    
    // 预加载 QQ 表情，避免第一次使用时卡顿
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [QDUIHelper qmuiEmotions];
    });
}

#pragma mark - TMFWebOffline
// 离线包下载进度监听回调
void downloadProgressHandler(NSString *Bid, NSProgress *progress) {
    NSLog(@"[TMFWebOffline Prog] download Bid:%@, progerss:%.2lf", Bid, progress.completedUnitCount * 1.0 / progress.totalUnitCount);
}

- (void)webOfflineNoSpaceHandler{
    NSLog(@"[⚠️][TMFWebOffline no space]");
}

- (void)prepareWebOffline {
    [TMFWebOfflineService setLogLevels:TMFBaseCoreLogLevelAll];
    [TMFWebOfflineService registerDownloadProgressHandler:downloadProgressHandler];

    [TMFWebOfflineService setFallbackEnabled:YES];
    
    // 使用tmf-ios-configurations.json中的离线包公钥信息
    NSString *publicKey = [TMFServerManager shareServerManager].serverConfiguration.webOfflineConfigurationPublicKey;
    [TMFWebOfflineService setPublicKey:publicKey];
    
    // Note: 通过个性化配置，定义了默认的离线包PUSH处理器，后续收到离线包的PUSH将由SDK自行处理
    //  同时 `TMFWebOfflineServiceShouldUpdateNotification` 将不再广播!!!
    //  PUSH处理策略：`不更新`，`仅WiFi下更新`，`WiFi和蜂窝都更新`
    TMFWebOfflineConfiguration *configuration = [TMFWebOfflineConfiguration configuration];
    configuration.pushHandlePolicy = TMFWebOfflinePushHandlePolicyWiFiAndCellular;
    configuration.pushPassagePolicy = TMFWebOfflinePushPassagePolicyPushGo;
    [TMFWebOfflineService activateWithConfiguration:configuration];
    [TMFWebOfflineService activate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webOfflineServiceShouldUpdate:) name:TMFWebOfflineServiceShouldUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(webOfflineNoSpaceHandler) name:(NSString *)TMFWebOfflineDownloadNoSpaceNotification object:nil];
}

- (void)checkUpdateWebOfflineAutomatically {
#if WEB_OFFLINE_TEST_AUTO_UPDATE
    static NSDate *lastUpdateTime = nil;
    // App 进前台时，每 30 分钟检查一次更新
    if (lastUpdateTime == nil || ABS([lastUpdateTime timeIntervalSinceNow]) > 30 * 60) {
        lastUpdateTime = [NSDate date];
        [TMFWebOfflineService checkAndUpdateWithBID:WEB_OFFLINE_TEST_BID completionHandler:^(BOOL isUpdated, NSError * _Nullable error) {
            // 自动更新离线包成功
        }];
    }
#endif
}

- (void)webOfflineServiceShouldUpdate:(NSNotification *)notification {
    // 离线包更新通知
    NSArray<NSString *> *BIDs = [notification.userInfo objectForKey:TMFWebOfflineServiceUpdatedBIDsKey];
    [self checkUpdateWebOfflineForcelyWithBIDs:BIDs];
}

- (void)checkUpdateWebOfflineForcelyWithBIDs:(NSArray<NSString *> *)BIDs {
    TMFWebOfflineServiceOptions *options = [TMFWebOfflineServiceOptions options];
    options.source = TMFWebOfflineServiceOptionsSourcePush;
    options.ignoresDelay = YES;
    options.ignoresFrequency = YES;
    [TMFWebOfflineService checkAndUpdateWithBIDs:BIDs options:options completionHandler:^(NSArray<NSString *> * _Nonnull updatedBIDs) {
        NSLog(@"updatedBIDs: %@", updatedBIDs);
    }];
}
#pragma mark - TMFPush

- (void)preparePush {
    [TMFPush setLogLevels:TMFBaseCoreLogLevelAll];
    [[TMFPush defaultManager] startPushWithDelegate:self];
    NSLog(@"[TMFPush] deviceToken: %@", [TMFPushTokenManager defaultTokenManager].deviceTokenString);
}

- (void)tmfPushDidRegisterDeviceToken:(NSString *)deviceToken error:(NSError *)error {
    NSLog(@"[TMFPush] did register deviceToken: %@, error: %@", deviceToken, error);
}

- (void)tmfPushDidReceiveRemoteNotification:(nonnull id)notification withCompletionHandler:(nullable void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"[TMFPush] did receive remote notification: %@", notification);
    if ([notification isKindOfClass:[NSDictionary class]]) {
        // NSDictionary
        NSDictionary *data = notification;
        for (NSString *key in data) {
            id value = data[key];
            NSLog(@"[TMFPush] key: %@, value: %@", key, value);
        }
        
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

- (void)tmfPushUserNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(nullable UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler API_AVAILABLE(ios(10.0)) {
    NSLog(@"[TMFPush] did receive remote notification(iOS10+): %@", notification);
    UNNotification *unNotification = notification;
    UNNotificationContent *content = unNotification.request.content;
    NSLog(@"[TMFPush] title: %@, body: %@", content.title, content.body);
    NSLog(@"[TMFPush] userInfo: %@", content.userInfo);
    
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionAlert|
                      UNNotificationPresentationOptionSound);
}

- (void)tmfPushUserNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(nullable UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)) {
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSLog(@"[TMFPush] did handle action for remote notification, userInfo: %@", userInfo);
    
    completionHandler();
}


#pragma mark - Distribution

- (void)prepareDistribution
{
    [TMFDistributionManager setLogLevels:TMFBaseCoreLogLevelAll];
    
    // 初始化
    [[TMFDistributionManager sharedManager] initialize];
}


#pragma mark - PushGo
- (void)preparePushGo{
    [TMFPushGoCenter setLogLevels:TMFBaseCoreLogLevelAll];
    [[TMFPushGoCenter shareCenter] performSelectorOnMainThread:@selector(activate) withObject:nil waitUntilDone:NO];
}


@end
