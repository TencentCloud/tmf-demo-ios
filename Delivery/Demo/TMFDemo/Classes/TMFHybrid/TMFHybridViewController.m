//
//  TMFHybridViewController.m
//  TMFDemo
//
//  Created by v_zwtzzhou on 2022/1/25.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "TMFHybridViewController.h"
#import "TMFHybridManager.h"
#import "TMFWebOfflineService.h"
#import "TMFHybridOpenURLViewController.h"
#import "TMFHybridOpenBIDViewController.h"
#import "TMFWkWebView.h"

#define ROW_OPEN_H5                 @"打开H5容器"

#define ROW_WEBOFFLINE_USE_FB       @"使用fallback"
#define ROW_WEBOFFLINE_USE_FBRP     @"启用fallback替换功能"
#define ROW_WEBOFFLINE_RH_SET       @"RemoteHost设置"
#define ROW_WEBOFFLINE_VH_SET       @"globalVirtualHost设置"
#define ROW_WEBOFFLINE_CMBID_SET    @"全局公共包设置"

#define ROW_WEBOFFLINE_REM          @"删除离线包"
#define ROW_OPEN_WEBOFFLINE_CLEAN   @"清理缓存"
#define ROW_OPEN_WEBOFFLINE_UNCOMPRESS      @"生效离线包"

#define ROW_WEBOFFLINE_OPEN_URL     @"打开离线包-URL"
#define ROW_WEBOFFLINE_OPEN_BID     @"打开离线包-BID"


#define ROW_LINE     @"----------------"
#define ROW_LINE2    @"-----------------"

@interface TMFHybridViewController ()

@property (nonatomic, assign) BOOL useFallback;
@property (nonatomic, copy) NSString *remoteHost;
@property (nonatomic, copy) NSString *virtualHost;
@property (nonatomic, copy) NSString *commonBid1;
@property (nonatomic, copy) NSString *commonBid2;
@property (nonatomic, copy) NSString *commonBid3;
@property (nonatomic, strong) UISwitch *switchBtn;
@property (nonatomic, strong) UISwitch *switchBtn2;

@end

@implementation TMFHybridViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.remoteHost = @"www.abc.com";
    self.virtualHost = @"www.abc.com";
    [TMFWebOfflineService setGlobalVirtualHost:self.virtualHost];
    [TMFWebOfflineService setRemoteHost:self.remoteHost];
    [TMFWebOfflineService setReplaceRemotePath:YES];
    [TMFHybridManager shareManager].scheme = @"http";
    self.useFallback = NO;
    
    [self initDataSource];
}

#pragma mark - Data Functions
- (void)initDataSource {
    [super initDataSource];

    QMUIOrderedDictionary<NSString *, NSString *> *dataSourceWithDetailText = [[QMUIOrderedDictionary alloc] init];
    [dataSourceWithDetailText setObject:@"" forKey:ROW_LINE];
    [dataSourceWithDetailText setObject:@"" forKey:ROW_WEBOFFLINE_USE_FB];
    [dataSourceWithDetailText setObject:@"" forKey:ROW_WEBOFFLINE_USE_FBRP];
    [dataSourceWithDetailText setObject:self.remoteHost ? self.remoteHost : @"" forKey:ROW_WEBOFFLINE_RH_SET];
    [dataSourceWithDetailText setObject:self.virtualHost ? self.virtualHost : @"" forKey:ROW_WEBOFFLINE_VH_SET];
    [dataSourceWithDetailText setObject:[self commonBids] forKey:ROW_WEBOFFLINE_CMBID_SET];
    [dataSourceWithDetailText setObject:@"" forKey:ROW_WEBOFFLINE_REM];
    [dataSourceWithDetailText setObject:@"" forKey:ROW_OPEN_WEBOFFLINE_CLEAN];
    [dataSourceWithDetailText setObject:@"" forKey:ROW_OPEN_WEBOFFLINE_UNCOMPRESS];

    [dataSourceWithDetailText setObject:@"" forKey:ROW_LINE2];
    [dataSourceWithDetailText setObject:@"" forKey:ROW_WEBOFFLINE_OPEN_URL];
    [dataSourceWithDetailText setObject:@"" forKey:ROW_WEBOFFLINE_OPEN_BID];

    self.dataSourceWithDetailText = dataSourceWithDetailText;
}

- (void)reloadTableView {
    [self initDataSource];
    [self.tableView reloadData];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    UISwitch *(^createSwitch)(void) = ^(){
        UISwitch *switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        switchBtn.center = CGPointMake(CGRectGetWidth(cell.contentView.bounds) - 40, CGRectGetMidY(cell.contentView.bounds));
        switchBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        return switchBtn;
    };
    
    
    NSString *keyName = self.dataSourceWithDetailText.allKeys[indexPath.row];
    if ([keyName isEqualToString:ROW_WEBOFFLINE_USE_FB]) {
        if (!_switchBtn) {
            _switchBtn = createSwitch();
            _switchBtn.on = [TMFWebOfflineService fallbackEnabled];
            [_switchBtn addTarget:self action:@selector(changeFallback:) forControlEvents:UIControlEventValueChanged];
        }
        [cell.contentView addSubview:_switchBtn];
    } else if ([keyName isEqualToString:ROW_WEBOFFLINE_USE_FBRP]) {
        if (!_switchBtn2) {
            _switchBtn2 = createSwitch();
            _switchBtn2.on = [TMFWebOfflineService isReplaceRemotePath];
            [_switchBtn2 addTarget:self action:@selector(changeFallbackReplace:) forControlEvents:UIControlEventValueChanged];
        }
        [cell.contentView addSubview:_switchBtn2];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if ([cell.contentView.subviews containsObject:_switchBtn]) {
        [_switchBtn removeFromSuperview];
    } else if ([cell.contentView.subviews containsObject:_switchBtn2]){
        [_switchBtn2 removeFromSuperview];
    }
}

- (void)changeFallback:(UISwitch *)switchBtn{
    TMFWebOfflineService.fallbackEnabled = switchBtn.on;
}

- (void)changeFallbackReplace:(UISwitch *)switchBtn{
    TMFWebOfflineService.replaceRemotePath = switchBtn.on;
}

- (void)didSelectCellWithTitle:(NSString *)title {
    if ([title isEqualToString:ROW_WEBOFFLINE_RH_SET]) {
        [self openAlerViewControllerWithMsg:@"Setting RemoteHost" text:self.remoteHost handler:^(NSString *text) {
            self.remoteHost = text;
            [TMFWebOfflineService setRemoteHost:self.remoteHost.length ? self.remoteHost : nil];
            [self reloadTableView];
        }];
    } else if ([title isEqualToString:ROW_WEBOFFLINE_VH_SET]) {
        [self openAlerViewControllerWithMsg:@"Setting VirtualHost" text:self.virtualHost handler:^(NSString *text) {
            self.virtualHost = text;
            [TMFWebOfflineService setGlobalVirtualHost:self.virtualHost.length ? self.virtualHost : nil];
            [self reloadTableView];
        }];
    } else if ([title isEqualToString:ROW_WEBOFFLINE_CMBID_SET]) {
        [self openCommonBIDsAlerViewController];
    }
    
    
    else if ([title isEqualToString:ROW_WEBOFFLINE_REM]) {
        [self openAlerViewControllerWithMsg:@"Removing BID" text:@"" handler:^(NSString *text) {
            [TMFWebOfflineService removeLocalPackageWithBID:text];
        }];
    } else if ([title isEqualToString:ROW_OPEN_WEBOFFLINE_CLEAN]) {
        [self openAlerViewControllerWithMsg:@"Clean Cache" text:@"" handler:^(NSString *text) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [TMFWebOfflineService clearPackageCacheWithBID:text];
            });
        }];
    } else if ([title isEqualToString:ROW_OPEN_WEBOFFLINE_UNCOMPRESS]) {
        [self openAlerViewControllerWithMsg:@"Clean Cache" text:@"" handler:^(NSString *text) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [TMFWebOfflineService uncompressPackagesIfNeeded];
            });
        }];
    }
    
    else if ([title isEqualToString:ROW_WEBOFFLINE_OPEN_URL]) {
        [self openURLWebOffline];
    }
    
    else if ([title isEqualToString:ROW_WEBOFFLINE_OPEN_BID]) {
        [self openBIDWebOffline];
    }
}

#pragma mark - Private Functions
- (void)openURLWebOffline{
    TMFHybridOpenURLViewController *vc = [[TMFHybridOpenURLViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openBIDWebOffline{
    TMFHybridOpenBIDViewController *vc = [[TMFHybridOpenBIDViewController alloc] init];
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
        [self.tableView reloadData];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
