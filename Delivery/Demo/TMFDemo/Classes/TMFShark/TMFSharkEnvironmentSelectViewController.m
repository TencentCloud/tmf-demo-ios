//
//  TMFSharkEnvironmentSelectViewController.m
//  TMFDemo
//
//  Created by v_zwtzzhou on 2022/9/21.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "TMFSharkEnvironmentSelectViewController.h"
#import "TMFSharkDemoUserConfiguration.h"

@implementation TMFSharkEnvironmentSelectViewController

#define TMF_ENVIRONMENT_DEFAULT     @"默认配置"
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择配置文件";
}

- (void)initDataSource {
    [super initDataSource];

    NSMutableArray *dataSource = [[TMFSharkEnvironmentConfiguration configFileLists] mutableCopy];
    if (dataSource && dataSource.count) {
        [dataSource insertObject:TMF_ENVIRONMENT_DEFAULT atIndex:0];
    }
    
    self.dataSource = dataSource;
}

- (void)reloadTableView {
    [self initDataSource];
    [self.tableView reloadData];
}

- (void)didSelectCellWithTitle:(NSString *)title{
    if ([title isEqualToString:TMF_ENVIRONMENT_DEFAULT]) {
        [TMFSharkEnvironmentConfiguration setConfigFileName:nil];
    } else {
        [TMFSharkEnvironmentConfiguration setConfigFileName:title];
    }
    [self resetEnvironmentConfiguration];
}

- (void)resetEnvironmentConfiguration {
    UIAlertController *alertController2 = [UIAlertController alertControllerWithTitle:@"Reset" message:@"Demo 将会重置数据并退出，重启 Demo 后生效"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController2 addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alertController2 addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [QMUITips showLoading:nil detailText:nil inView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            abort();
        });
    }]];
    [self presentViewController:alertController2 animated:YES completion:nil];
}


@end
