//
//  TMFDistributionViewController.m
//  TMFDemo
//
//  Created by bentonxiu on 2019/8/8.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "TMFDistributionViewController.h"
#import "TMFDistribution.h"
#import <QMUIKit/QMUIKit.h>
#import "NSString+Localize.h"

@implementation TMFDistributionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"TMFDistribution";
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [customButton setTitle:[@"Automatically check for updates" localizedString] forState:UIControlStateNormal];
    [customButton addTarget:self action:@selector(onCustomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    customButton.frame = CGRectMake(0, 100, 200, 50);
    [self.view addSubview:customButton];
    
    UIButton *drivingButton = [UIButton buttonWithType:UIButtonTypeSystem];
    drivingButton.tag = 10;
    [drivingButton setTitle:[@"Manually check the update sheet" localizedString] forState:UIControlStateNormal];
    [drivingButton addTarget:self action:@selector(onCustomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    drivingButton.frame = CGRectMake(0, 250, 200, 50);

    [self onCustomButtonClicked:customButton];
    [self.view addSubview:drivingButton];
}

- (void)onCustomButtonClicked:(UIButton *)sender
{
    if (sender.tag == 10){
        [[TMFDistributionManager sharedManager] drivingCheckForUpdatesDistributionHandler:^(TMFDistributionInfo * _Nullable distributionInfo, NSError * _Nullable error, TMFDistributionCompletionBlock  _Nullable completionHandler) {
            
            
            if (error) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"TMFDistribution"
                                                                                         message:[NSString stringWithFormat:@"Failed to obtain the update sheet\n error = %@",error]
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
                return;
            }
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:distributionInfo.distributionTitle
                                                                                     message:distributionInfo.featureDescription
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {

            }];
            UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"Update" style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     [self _jumpAppStoreWithURL:distributionInfo.appStoreURL];
                                                                 }];
            [alertController addAction:updateAction];
            if (!distributionInfo.updatesForcibly) {
                [alertController addAction:cancelAction];
            }
            
            // 弹出弹窗
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        }];
        return;
    }
    
    // 注册自定义弹窗处理
    [[TMFDistributionManager sharedManager] autoCheckForUpdatesDistributionHandler:nil];
}

- (void)_jumpAppStoreWithURL:(NSURL *)appStoreURL
{
    if ([[UIApplication sharedApplication] canOpenURL:appStoreURL]) {
        if (@available(iOS 10, *)) {
            [[UIApplication sharedApplication] openURL:appStoreURL options:@{} completionHandler:^(BOOL success) {
            }];
        } else {
            [[UIApplication sharedApplication] openURL:appStoreURL];
        }
    }
}
@end
