//
//  SonicRootViewController.m
//  TMFDemo
//
//  Created by hauzhong on 2019/5/26.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "SonicRootViewController.h"
#import "SonicWebViewController.h"
#import "SonicOfflineCacheConnection.h"
#import "SonicEventObserver.h"

#import <VasSonic/Sonic.h>

@interface SonicRootViewController ()

@property (nonatomic,strong) NSString *url;
@end

@implementation SonicRootViewController

- (void)initDataSource {
    [super initDataSource];
    self.url = @"http://mc.vip.qq.com/demo/indexv3";
    self.dataSource = @[@"LOAD WITHOUT SONIC",
                        @"LOAD WITH SONIC",
                        @"LOAD WITH UNSTRICT SONIC",
                        @"LOAD WITH RESOURCE PRELOAD",
                        @"LOAD SONIC WITH OFFLINE CACHE",
                        @"DO SONIC PRELOAD",
                        @"CLEAN UP CACHE"
                        ];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    if ([title isEqualToString:@"LOAD WITHOUT SONIC"]) {
        [self normalRequestAction];
    } else if ([title isEqualToString:@"LOAD WITH SONIC"]) {
        [self sonicRequestAction];
    } else if ([title isEqualToString:@"LOAD WITH UNSTRICT SONIC"]) {
        [self unstrictModeSonicRequestAction];
    } else if ([title isEqualToString:@"LOAD WITH RESOURCE PRELOAD"]) {
        [self sonicResourcePreloadAction];
    } else if ([title isEqualToString:@"LOAD SONIC WITH OFFLINE CACHE"]) {
        [self loadWithOfflineFileAction];
    } else if ([title isEqualToString:@"DO SONIC PRELOAD"]) {
        [self sonicPreloadAction];
    } else if ([title isEqualToString:@"CLEAN UP CACHE"]) {
        [self clearAllCacheAction];
    }
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"VasSonic";
}

- (void)normalRequestAction
{
    SonicWebViewController *webVC = [[SonicWebViewController alloc]initWithUrl:self.url useSonicMode:NO unStrictMode:NO];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)sonicResourcePreloadAction
{
    SonicWebViewController *webVC = [[SonicWebViewController alloc]initWithUrl:@"http://www.kgc.cn/zhuanti/bigca.shtml?jump=1" useSonicMode:YES unStrictMode:YES];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)sonicPreloadAction
{
    [[SonicEngine sharedEngine] createSessionWithUrl:self.url withWebDelegate:nil];
    [self alertMessage:@"Preload Start!"];
}

- (void)sonicRequestAction
{
    SonicWebViewController *webVC = [[SonicWebViewController alloc]initWithUrl:self.url useSonicMode:YES unStrictMode:NO];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)unstrictModeSonicRequestAction
{
    SonicWebViewController *webVC = [[SonicWebViewController alloc]initWithUrl:@"http://www.kgc.cn/zhuanti/bigca.shtml?jump=1" useSonicMode:YES unStrictMode:YES];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)loadWithOfflineFileAction
{
    SonicWebViewController *webVC = [[SonicWebViewController alloc]initWithUrl:@"http://mc.vip.qq.com/demo/indexv3?offline=1" useSonicMode:YES unStrictMode:NO];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)clearAllCacheAction
{
    [[SonicEngine sharedEngine] clearAllCache];
    [self alertMessage:@"Clear Success!"];
}

- (void)alertMessage:(NSString *)message
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
#pragma clang diagnostic pop
    [alert show];
}

@end
