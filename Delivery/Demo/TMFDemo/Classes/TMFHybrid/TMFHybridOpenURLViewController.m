//
//  TMFHybridOpenURLViewController.m
//  TMFDemo
//
//  Created by v_zwtzzhou on 2022/7/5.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "TMFHybridOpenURLViewController.h"
#import "TMFHybridManager.h"
#import "TMFWebOfflineService.h"

#define ROW_URL             @"URL"
#define ROW_MAIN_BID        @"主包"
#define ROW_COMMON_BID      @"公共包"

#define ROW_LINE            @"----------------"
#define ROW_OPEN            @"打开URL"

@interface TMFHybridOpenURLViewController ()

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *mainBid;
@property (nonatomic, strong) NSString *commonBid1;
@property (nonatomic, strong) NSString *commonBid2;
@property (nonatomic, strong) NSString *commonBid3;

@end

@implementation TMFHybridOpenURLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /// 以iosuttHost为例
    self.urlString = @"http://www.abc.com/iosuttHost/index.html";
    self.mainBid = @"iosuttHost";
}

- (void)initDataSource {
    [super initDataSource];

    QMUIOrderedDictionary<NSString *, NSString *> *dataSourceWithDetailText = [[QMUIOrderedDictionary alloc] init];
    [dataSourceWithDetailText setObject:self.urlString ? self.urlString : @"" forKey:ROW_URL];
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
        [self openAlerViewControllerWithMsg:@"Setting URL" text:self.urlString handler:^(NSString *text) {
            self.urlString = text;
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
    if (!self.urlString || 0 == self.urlString) {
        [self openAlerViewControllerWithMsg:@"Unavailable URL!"];
        return;
    }
    NSURLComponents *urlComp = [[NSURLComponents alloc] initWithString:self.urlString];
    if (self.mainBid && self.mainBid.length) {
        NSString *bidStr = self.mainBid;
        if ([self commonBids].length) {
            bidStr = [bidStr stringByAppendingFormat:@"+%@", [self commonBids]];
        }
        NSURLQueryItem *query = [[NSURLQueryItem alloc] initWithName:@"_bids" value:bidStr];
        urlComp.queryItems = @[query];
    }
    
    TMFWebViewController *vc = [[TMFHybridManager shareManager] createOfflineWebViewControllerWithURL:urlComp.URL];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithTitle:@"URL" target:self action:@selector(showURL:)];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showURL:(UIBarButtonItem *)buttonItem{
    
}


- (void)openAlerViewControllerWithMsg:(NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
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

/**
 https://www.abc.com/iosuttHost/index.html
 
 
 */
