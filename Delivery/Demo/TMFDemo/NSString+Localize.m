//
//  NSString+Localize.m
//  TMFDemo
//
//  Created by 许加文 on 2022/12/27.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "NSString+Localize.h"

@implementation NSString (Localize)

- (NSString *)localizedString {
    return NSLocalizedString(self, nil);
}

+ (BOOL)isCN {
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSArray  *array = [language componentsSeparatedByString:@"-"];
    NSString *currentLanguage = array[0];
    return [currentLanguage isEqualToString:@"zh"];
}

@end
