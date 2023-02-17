//
//  TMFDevelopSetting.h
//  TMFDemo
//
//  Created by v_zwtzzhou on 2021/10/9.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * TMFDevelopInstructionVersion;
extern NSString * TMFDevelopChristVersion;
extern NSString * TMFDevelopDistributionVersion;
extern NSString * TMFDevelopWebOfflineVersion;

@interface TMFDevelopSetting : NSObject

+ (void)saveSetting:(NSDictionary *)developSettings;;
+ (NSDictionary *)localDevelopSettings;

@end

NS_ASSUME_NONNULL_END
