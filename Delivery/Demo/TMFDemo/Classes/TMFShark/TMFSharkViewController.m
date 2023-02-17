//
//  TMFSharkViewController.m
//  TMFDemo
//
//  Created by klaudz on 16/4/2019.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "TMFSharkViewController.h"
#import "TMFSharkCenter.h"
#import "TMFSharkCenter+Profile.h"
#import "TMFSharkCenter.h"
#import "TMFSharkCenterConfiguration.h"
#import "TMFProfile.h"
#import "TMFSharkEnvironmentSelectViewController.h"

#import "QMUITips.h"
#import "NSURL+MQQExtended.h"
#import "NSString+Localize.h"

@implementation TMFSharkViewController {
    NSString *_customizedUserID;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initDataSource];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sharkCenterDidRegisterGUID:)
                                                     name:TMFSharkCenterDidRegisterGUIDNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self
                                                                          action:@selector(resetEnvironmentConfiguration)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

#define ROW_PRODUCT_KEY      @"ProductKey"
#define ROW_PRODUCT_ID       @"ProductID"
#define ROW_HTTP_URL         @"HTTPURL"
#define ROW_PUBLIC_KEY       @"PublicKey"
#define ROW_GUID             @"GUID"
#define ROW_VID              @"VID"

- (void)initDataSource {
    [super initDataSource];

    TMFSharkCenter *center = [TMFSharkCenter masterCenter];
    TMFSharkCenterConfiguration *configuration = center.configuration;

    QMUIOrderedDictionary<NSString *, NSString *> *dataSourceWithDetailText = [[QMUIOrderedDictionary alloc] init];

    [dataSourceWithDetailText setObject:(configuration.productKey ?: @"") forKey:ROW_PRODUCT_KEY];
    [dataSourceWithDetailText setObject:[NSString stringWithFormat:@"%ld", (long)configuration.productID] forKey:ROW_PRODUCT_ID];
    [dataSourceWithDetailText setObject:(configuration.HTTPURL ?: @"") forKey:ROW_HTTP_URL];
    [dataSourceWithDetailText setObject:(configuration.RSAPublicKey ?: @"") forKey:ROW_PUBLIC_KEY];
    [dataSourceWithDetailText setObject:(center.GUID ?: @"") forKey:ROW_GUID];
    [dataSourceWithDetailText setObject:@"Click to fetch VID" forKey:ROW_VID];

    self.dataSourceWithDetailText = dataSourceWithDetailText;
}

- (void)reloadTableView {
    [self initDataSource];
    [self.tableView reloadData];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    if ([title isEqualToString:ROW_PRODUCT_KEY]) {
        //[self updateConfiguration];
    } else if ([title isEqualToString:ROW_PRODUCT_ID]) {
        //[self updateConfiguration];
    } else if ([title isEqualToString:ROW_HTTP_URL]) {
        //[self updateConfiguration];
    } else if ([title isEqualToString:ROW_PUBLIC_KEY]) {
        //[self updateConfiguration];
    } else if ([title isEqualToString:ROW_GUID]) {
        [self copyGUID];
    } else if ([title isEqualToString:ROW_VID]) {
        [self fetchVID];
    }
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"TMFShark";
}
#pragma mark -

- (void)sharkCenterDidRegisterGUID:(NSNotification *)notification {
    [self reloadTableView];
}
 
- (void)copyGUID {
    NSString *GUID = [TMFSharkCenter masterCenter].GUID;
    if (GUID) {
        [[UIPasteboard generalPasteboard] setString:GUID];
        NSLog(@"[TMFShark] GUID: %@", GUID);
        [QMUITips showSucceed:[@"GUID has copied to clipboard" localizedString] inView:self.view hideAfterDelay:2.0];
    }
}

- (void)fetchVID {
    [QMUITips showLoading:nil detailText:nil inView:self.view];
    [[TMFSharkCenter masterCenter] fetchVID:^(NSString *_Nullable VID, NSError *_Nullable error) {
        [QMUITips hideAllTipsInView:self.view];
        if (VID) {
            [[UIPasteboard generalPasteboard] setString:VID];
            NSLog(@"[TMFShark] VID: %@", VID);
            UIAlertController *alertController =
                [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:[@"VID: %@\nhas copied to clipboard" localizedString], VID]
                                             preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            UIAlertController *alertController =
                [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:[@"get VID fail\nError: %@" localizedString], error]
                                             preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}
- (void)resetEnvironmentConfiguration {
    [self.navigationController pushViewController:[TMFSharkEnvironmentSelectViewController new] animated:YES];
}

@end
