//
//  TMFHybridOpenBIDViewController.m
//  TMFDemo
//
//  Created by v_zwtzzhou on 2022/7/5.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "TMFHybridOpenBIDViewController.h"
#import "TMFHybridManager.h"
#import "TMFWebOfflineService.h"

#define ROW_URL             @"indexPath"
#define ROW_MAIN_BID        @"主包"
#define ROW_COMMON_BID      @"公共包"

#define ROW_LINE            @"----------------"
#define ROW_OPEN            @"打开URL"

@interface TMFHybridOpenBIDViewController ()

@property (nonatomic, strong) NSString *indexPath;
@property (nonatomic, strong) NSString *mainBid;
@property (nonatomic, strong) NSString *commonBid1;
@property (nonatomic, strong) NSString *commonBid2;
@property (nonatomic, strong) NSString *commonBid3;

@end

@implementation TMFHybridOpenBIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"打开BID";
    /// Demo中预置离线包为webappCachein.zip中的四个bid（iosuttBid、iosuttBidHost、iosuttG、iosuttHost），其中iosuttG不可用，这里默认为iosuttBid
    self.mainBid = @"iosuttBid";
    // Do any additional setup after loading the view.
}

- (void)initDataSource {
    [super initDataSource];

    QMUIOrderedDictionary<NSString *, NSString *> *dataSourceWithDetailText = [[QMUIOrderedDictionary alloc] init];
    [dataSourceWithDetailText setObject:self.indexPath ? self.indexPath : @"" forKey:ROW_URL];
    [dataSourceWithDetailText setObject:self.mainBid ? self.mainBid : @"" forKey:ROW_MAIN_BID];
    [dataSourceWithDetailText setObject:[self commonBids] forKey:ROW_COMMON_BID];
    [dataSourceWithDetailText setObject:@"" forKey:ROW_LINE];
    [dataSourceWithDetailText setObject:@"" forKey:ROW_OPEN];

    self.dataSourceWithDetailText = dataSourceWithDetailText;
}

- (NSString *)commonBids{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if (self.commonBid1 && self.commonBid1.length) {
        [arr addObject:self.commonBid1];
    }
    if (self.commonBid2 && self.commonBid2.length) {
        [arr addObject:self.commonBid2];
    }
    if (self.commonBid3 && self.commonBid3.length) {
        [arr addObject:self.commonBid3];
    }
    NSString *bids = [arr componentsJoinedByString:@"+"];
    if (bids && bids.length) {
        return bids;
    } else {
        return @"";
    }
}

- (void)didSelectCellWithTitle:(NSString *)title {
    if ([title isEqualToString:ROW_URL]) {
        [self openAlerViewControllerWithMsg:@"Setting IndexPath" text:self.indexPath handler:^(NSString *text) {
            self.indexPath = text;
            [self reloadTableView];
        }];
    } else if ([title isEqualToString:ROW_MAIN_BID]) {
        [self openAlerViewControllerWithMsg:@"Setting Main Bid" text:self.mainBid handler:^(NSString *text) {
            self.mainBid = text;
            [self reloadTableView];
        }];
    } else if ([title isEqualToString:ROW_COMMON_BID]) {
        [self openCommonBIDsAlerViewController];
    } else if ([title isEqualToString:ROW_OPEN]) {
        [self openWebOffline];
    }
}

- (void)reloadTableView {
    [self initDataSource];
    [self.tableView reloadData];
}


- (void)openWebOffline{
    UIViewController *vc = [[TMFHybridManager shareManager] createOfflineWebViewControllerWithMainBID:self.mainBid commonBIDs:[[self commonBids] componentsSeparatedByString:@"+"] indexPath:self.indexPath param:nil fragment:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openAlerViewControllerWithMsg:(NSString *)msg text:(NSString *)text handler:(void (^ __nullable)(NSString *text))handler {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.text = text;
        textField.placeholder = text;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Go" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        if (handler) {
            handler(alert.textFields.firstObject.text);
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)openCommonBIDsAlerViewController {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Setting Common Bids" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.text = self.commonBid1;
        textField.placeholder = @"commonBid1";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.text = self.commonBid2;
        textField.placeholder = @"commonBid2";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.text = self.commonBid3;
        textField.placeholder = @"commonBid3";
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"Go" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        self.commonBid1 = alert.textFields[0].text;
        self.commonBid2 = alert.textFields[1].text;
        self.commonBid3 = alert.textFields[2].text;
        [self reloadTableView];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
