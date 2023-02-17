//
//  NSString+Localize.h
//  TMFDemo
//
//  Created by 许加文 on 2022/12/27.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Localize)

- (NSString *)localizedString;

+ (BOOL)isCN;

@end

NS_ASSUME_NONNULL_END
