//
//  TMFWebOfflineWebViewDebugLogViewController.m
//  TMFDemo
//
//  Created by hauzhong on 2019/4/12.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "TMFWebOfflineWebViewDebugLogViewController.h"

@interface TMFWebOfflineWebViewDebugLogViewController ()

@end

@implementation TMFWebOfflineWebViewDebugLogViewController

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        //self.setSuperTitle = @"返回";
    }
    return self;
}

- (void)dealloc {
    if (self.sourceTextList) {
        self.sourceTextList = nil;
    }
    
    self.sourceArray = nil;
    self.sumLog = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma -mark loadView
- (void)loadView {
    [super loadView];
    self.title = @"WebView日志";
    CGRect rect = {0,0,self.view.bounds.size.width,self.view.bounds.size.height};
    self.sourceTextList = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    
    self.sourceTextList.delegate = self;
    self.sourceTextList.dataSource = self;
    self.sourceTextList.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.sourceTextList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWilAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (_sourceTextList) {
        [_sourceTextList reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)nowTimeStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    //[dateFormatter setDateFormat:@"hh:mm:ss"]
    [dateFormatter setDateFormat:@"YYYYMMdd_HH_mm_ss"];

    NSString *time = [dateFormatter stringFromDate:[NSDate date]];
    return time;
}


#pragma mark - UITabelViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1 ;
    }
    else if(section == 1) {
        
        return self.sourceArray.count;
    }

    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize maxsize = CGSizeMake(290, CGFLOAT_MAX);

    NSString* tmp = @"";

    if (indexPath.section == 0) {
        if (self.sumLog.length > 0)
        {
           tmp = self.sumLog;
        }
    }
    else if (indexPath.section == 1) {
        id item  = self.sourceArray[indexPath.row];
        
        if ([item isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)item;
            for (NSString *key in dict.allKeys ) {
                tmp = key;
            }
            
        }
        else if ([item isKindOfClass:[NSString class]]) {
            tmp = item;
        }
 
    }
    
    CGRect rect = [tmp boundingRectWithSize:maxsize options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil];
    return rect.size.height+20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"webContentSourceListCell"];
    if (cell  == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"webContentSourceListCell"];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont  systemFontOfSize:13];
    }
    
    NSString* tmp = @"";
    
    if (indexPath.section == 0) {
        if (self.sumLog.length > 0) {
            tmp = self.sumLog;
        }
    }
    else if (indexPath.section == 1) {
        id item  = self.sourceArray[indexPath.row];
        
        if ([item isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)item;
            for (NSString *key in dict.allKeys ) {
               tmp =  key;
                
                id logItem = dict[key];
                
                if ([logItem isKindOfClass:[NSArray class]]) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
            }
        }
        else if ([item isKindOfClass:[NSString class]]) {
            tmp = item;
        }
    }
    cell.textLabel.text =  tmp;
 
    return cell;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* tmp = @"";
    
    if (indexPath.section == 0) {
        
    } else if (indexPath.section == 1) {
        id item  = self.self.sourceArray[indexPath.row];
        
        if ([item isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)item;
            for (NSString *key in dict.allKeys ) {
                id logItem = dict[key];
                
                if ([logItem isKindOfClass:[NSArray class]]) {

                    //
                    TMFWebOfflineWebViewDebugLogViewController *vc = [[TMFWebOfflineWebViewDebugLogViewController alloc] init];
                    
                    vc.sumLog = key;
                    vc.sourceArray = logItem;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else if ([logItem isKindOfClass:[NSString class]]) {
                    tmp = logItem;
                }
            }
            
        }
        else if ([item isKindOfClass:[NSString class]]) {
            tmp = item;
        }
    }

}

@end
