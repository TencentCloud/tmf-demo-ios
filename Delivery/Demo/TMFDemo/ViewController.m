//
//  ViewController.m
//  TMFDemo
//
//  Created by klaudz on 5/4/2019.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Localize.h"
// TMFShark
#import "TMFSharkViewController.h"

// QMUIKit
#import <QMUIKit/QMUIKit.h>
#import "QDCommonUI.h"
#import "QDUIHelper.h"
#import "QDThemeManager.h"
#import "QDTabBarViewController.h"
#import "QDNavigationController.h"
#import "QDUIKitViewController.h"
#import "QDComponentsViewController.h"
#import "QDLabViewController.h"

// TMFWebOffline
#import "TMFWebOfflineViewController.h"

// TMFPush
#import "TMFPush.h"
// TMFDistribution
#import "TMFDistributionViewController.h"
// DevelopSetting
#import "TMFDevelopSettingViewController.h"

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self
                                                                          action:@selector(rightBarButtonItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

    // 解决低版本导航条覆盖问题
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0) {
        if (@available(iOS 7.0, *)) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
#if DEBUG
    if (@available(iOS 13.0, *)) {
        [self fixNavigationBarAlpha];
    }
#endif
}

#pragma mark NavigationbarAlphaFix
- (void)fixNavigationBarAlpha{
    UINavigationBar *bar = self.navigationController.navigationBar;
    UIImageView *imageView = [self printSubViews:bar floor:0];
    if (imageView) {
        [imageView addObserver:self forKeyPath:@"alpha" options:NSKeyValueObservingOptionNew context:nil];
    }
}

static const double imgView_alpha = 0.90980398654937744;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"alpha"] && [object isKindOfClass:[UIImageView class]]) {
        UIView *view = object;
        if ([[change objectForKey:@"new"] doubleValue] != imgView_alpha) {
            dispatch_async(dispatch_get_main_queue(), ^{
                view.alpha = imgView_alpha;
            });
        }
        return;
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (UIImageView *)printSubViews:(UIView *)view floor:(int)floor{
    if ([view isKindOfClass:[UIImageView class]]) {
        return (UIImageView *)view;
    }
    int i = 0;
    for (; i < floor; i++) {
        printf(" ");
    }
    NSLog(@"%@\n", view);
    for (UIView *subView in view.subviews) {
        UIImageView *resView = [self printSubViews:subView floor:floor+1];
        if (resView) {
            return resView;
        }
    }
    return nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initDataSource];
}
#define ROW_TMFSHARK                @"TMFShark"
#define ROW_TMFSHARK_DETAIL         [@"mobile gateway" localizedString]

#define ROW_TMFWEBOFFLINE           @"TMFWebOffline"
#define ROW_TMFWEBOFFLINE_DETAIL    [@"web offline" localizedString]

#define ROW_TMFPUSH                 @"TMFPush"
#define ROW_TMFPUSH_DETAIL          [@"remote push" localizedString]

#define ROW_QMUI                    @"QMUI"
#define ROW_QMUI_DETAIL             [@"UI module" localizedString]

#define ROW_TMFSSL                  @"TMFSSL"
#define ROW_TMFSSL_DETAIL           [@"encryption module" localizedString]

#define ROW_TMFDISTRIBUTION         @"TMFDistribution"
#define ROW_TMFDISTRIBUTION_DETAIL  [@"distribute management" localizedString]


- (void)initDataSource {
    [super initDataSource];
    
    QMUIOrderedDictionary<NSString *, NSString *> *dataSourceWithDetailText = [[QMUIOrderedDictionary alloc] init];
    
    [dataSourceWithDetailText setObject:ROW_TMFSHARK forKey:ROW_TMFSHARK_DETAIL];
    [dataSourceWithDetailText setObject:ROW_TMFWEBOFFLINE forKey:ROW_TMFWEBOFFLINE_DETAIL];
    [dataSourceWithDetailText setObject:ROW_QMUI forKey:ROW_QMUI_DETAIL];
    [dataSourceWithDetailText setObject:ROW_TMFSSL forKey:ROW_TMFSSL_DETAIL];
    [dataSourceWithDetailText setObject:ROW_TMFPUSH forKey:ROW_TMFPUSH_DETAIL];
    [dataSourceWithDetailText setObject:ROW_TMFDISTRIBUTION forKey:ROW_TMFDISTRIBUTION_DETAIL];
    
    self.dataSourceWithDetailText = dataSourceWithDetailText;
}

- (void)didSelectCellWithTitle:(NSString *)title {
    
    if ([title isEqualToString:ROW_TMFSHARK_DETAIL]) {
        [self createTMFSharkViewController];
    } else if ([title isEqualToString:ROW_TMFWEBOFFLINE_DETAIL]) {
        [self createTMFWebOfflineController];
    }  else if ([title isEqualToString:ROW_TMFPUSH_DETAIL]) {
        [self createTMFPushController];
    } else if ([title isEqualToString:ROW_QMUI_DETAIL]) {
        [self createQMUITabBarController];
    } else if ([title isEqualToString:ROW_TMFDISTRIBUTION_DETAIL]) {
        [self createDistributionController];
    }
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"TMF-Demo";
}

#pragma mark - TMFShark

- (void)createTMFSharkViewController {
    TMFSharkViewController *viewController = [[TMFSharkViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - QMUIKit

- (void)createQMUITabBarController {
    QDTabBarViewController *tabBarViewController = [[QDTabBarViewController alloc] init];

    // QMUIKit
    QDUIKitViewController *uikitViewController = [[QDUIKitViewController alloc] init];
    uikitViewController.hidesBottomBarWhenPushed = NO;
    //    QDNavigationController *uikitNavController = [[QDNavigationController alloc] initWithRootViewController:uikitViewController];
    uikitViewController.tabBarItem =
        [QDUIHelper tabBarItemWithTitle:@"QMUIKit" image:[UIImageMake(@"icon_tabbar_uikit") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                          selectedImage:UIImageMake(@"icon_tabbar_uikit_selected")
                                    tag:0];
    AddAccessibilityHint(uikitViewController.tabBarItem, @"展示一系列对系统原生控件的拓展的能力");

    // UIComponents
    QDComponentsViewController *componentViewController = [[QDComponentsViewController alloc] init];
    componentViewController.hidesBottomBarWhenPushed = NO;
    //    QDNavigationController *componentNavController = [[QDNavigationController alloc] initWithRootViewController:componentViewController];
    componentViewController.tabBarItem =
        [QDUIHelper tabBarItemWithTitle:@"Components"
                                  image:[UIImageMake(@"icon_tabbar_component") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                          selectedImage:UIImageMake(@"icon_tabbar_component_selected")
                                    tag:1];
    AddAccessibilityHint(componentViewController.tabBarItem, @"展示 QMUI 自己的组件库");

    // Lab
    QDLabViewController *labViewController = [[QDLabViewController alloc] init];
    labViewController.hidesBottomBarWhenPushed = NO;
    //    QDNavigationController *labNavController = [[QDNavigationController alloc] initWithRootViewController:labViewController];
    labViewController.tabBarItem =
        [QDUIHelper tabBarItemWithTitle:@"Lab" image:[UIImageMake(@"icon_tabbar_lab") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                          selectedImage:UIImageMake(@"icon_tabbar_lab_selected")
                                    tag:2];
    AddAccessibilityHint(labViewController.tabBarItem, @"集合一些非正式但可能很有用的小功能");

    tabBarViewController.title = @"QMUI_demo";
    tabBarViewController.viewControllers = @[uikitViewController, componentViewController, labViewController];
    [self.navigationController pushViewController:tabBarViewController animated:YES];
}

#pragma mark - TMFWebOffline

- (void)createTMFWebOfflineController {
    TMFWebOfflineViewController *viewController =  [[TMFWebOfflineViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark - TMFPush

- (void)createTMFPushController {
    NSString *deviceToken = [TMFPushTokenManager defaultTokenManager].deviceTokenString;
    NSMutableString *message = [NSMutableString string];
    if (deviceToken) {
        [[UIPasteboard generalPasteboard] setString:deviceToken];
        [message appendFormat:@"deviceToken: %@\n", deviceToken];
        [message appendString:[@"copied to clipboard" localizedString]];
    } else {
        [message appendFormat:@"deviceToken: %@", deviceToken];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"TMFPush" message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - TMFDistributionController

- (void)createDistributionController {
    TMFDistributionViewController *VC = [[TMFDistributionViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

@end
