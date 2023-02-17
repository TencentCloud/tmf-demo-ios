//
//  TMFDevelopSetting.m
//  TMFDemo
//
//  Created by v_zwtzzhou on 2021/10/9.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TMFDevelopSetting.h"

NSString * TMFDevelopInstructionVersion         = @"ISNTRUCTION_VERSION";
NSString * TMFDevelopChristVersion              = @"CHRIST_VERSION";
NSString * TMFDevelopDistributionVersion        = @"DISTRIBUTION_VERSION";
NSString * TMFDevelopWebOfflineVersion          = @"WEBOFFLINE_VERSION";

@implementation TMFDevelopSetting

+ (NSDictionary *)localDevelopSettings {
    NSString *settingPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    settingPath = [settingPath stringByAppendingPathComponent:@"DevelopSettings.plist"];
   
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:settingPath];
    if (!dic) {
        dic = @{TMFDevelopInstructionVersion:@(NO),
                TMFDevelopChristVersion:@(NO),
                TMFDevelopDistributionVersion:@(NO),
                TMFDevelopWebOfflineVersion:@(NO),
        };
        [dic writeToFile:settingPath atomically:YES];
    }
    return dic;
}

+ (void)saveSetting:(NSDictionary *)developSettings{
    NSString *settingPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    settingPath = [settingPath stringByAppendingPathComponent:@"DevelopSettings.plist"];
    [developSettings writeToFile:settingPath atomically:YES];
}


@end
