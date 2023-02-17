//
//  TMFDevelopSettingViewController.m
//  TMF
//
//  Created by v_zwtzzhou on 2021/10/8.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TMFDevelopSettingViewController.h"
#import "TMFDevelopSettingCell.h"
#import "TMFDevelopSetting.h"

@interface TMFDevelopSettingViewController ()<TMFDevelopSettingCellDelegate>

/**
 @brief 开发设置
 */
@property (nonatomic, strong) NSMutableDictionary *developSettings;

/**
 @brief 配置项key
 */
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation TMFDevelopSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Develop Setting";
    
    self.developSettings = [[TMFDevelopSetting localDevelopSettings] mutableCopy];
    self.dataSource = self.developSettings.allKeys;
    
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"⚠️" message:@"配置更新后需要重新启动App！" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TMFDevelopSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TMFDevelopSettingCell"    ];
    if (!cell) {
        cell = [[TMFDevelopSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TMFDevelopSettingCell"];
        cell.delegate = self;
    }
    NSString *key = self.dataSource[indexPath.row];
    cell.textLabel.text = key;
    cell.swButton.on = ((NSNumber *)self.developSettings[key]).boolValue;
    return cell;
}

- (void)switchButtonCell:(TMFDevelopSettingCell *)cell changeValue:(BOOL)value {
    [self.developSettings setValue:@(value) forKey:cell.textLabel.text];
    [TMFDevelopSetting saveSetting:self.developSettings];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
