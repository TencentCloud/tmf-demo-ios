//
//  TMFWebOfflineWebViewDebugLogViewController.h
//  TMFDemo
//
//  Created by hauzhong on 2019/4/12.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TMFWebOfflineWebViewDebugLogViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) UITableView *sourceTextList;
@property (nonatomic,retain) NSArray *sourceArray;
@property (nonatomic,retain) NSString *sumLog;

@end
