//
//  TMFSharkDemoUserConfiguration.m
//  TMFDemo
//
//  Created by klaudz on 7/5/2019.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "TMFSharkDemoUserConfiguration.h"

@implementation TMFSharkDemoUserConfiguration

#define _GetterAndSetter_(name, defaultValue)                                               \
+ (NSString *)u_##name                                                                      \
{                                                                                           \
    return [[NSUserDefaults standardUserDefaults] stringForKey:@#name] ? : defaultValue;    \
}                                                                                           \
                                                                                            \
+ (void)setU_##name :(NSString *)u_##name                                                   \
{                                                                                           \
    [[NSUserDefaults standardUserDefaults] setObject:u_##name forKey:@#name];               \
}                                                                                           \

_GetterAndSetter_(cmd,                          @"TMFEcho")
_GetterAndSetter_(cmdIDString,                  @"0")
_GetterAndSetter_(requestHeadersJSONString,     @"{ \"test_header_0\": \"header_0\" }")
_GetterAndSetter_(requestCookiesJSONString,     @"{ \"test_cookie_0\": \"cookie_0\" }")
_GetterAndSetter_(requestQueriesString,         @"test_query_0=query_0&test_query_1=query_1")
_GetterAndSetter_(requestDataString,            @"Hello World!!!")

+ (void)synchronize
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end


#define TMF_DEMO_ENVIRONMENT_FILE_NAME  @"TMFDemoEnvironmentFileName"
#define TMF_DEMO_ENVIRONMENT_DIRECTORY  @"Environment"
@implementation TMFSharkEnvironmentConfiguration

+ (void)setConfigFileName:(NSString *)configFileName{
    if (configFileName) {
        [[NSUserDefaults standardUserDefaults] setObject:configFileName forKey:TMF_DEMO_ENVIRONMENT_FILE_NAME];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:TMF_DEMO_ENVIRONMENT_FILE_NAME];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)configFileName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:TMF_DEMO_ENVIRONMENT_FILE_NAME];
}

+ (NSString *)configFilePath{
    NSString *fileName = [self configFileName];
    if (fileName && fileName.length) {
        NSString *filePath = [[self configDirectory] stringByAppendingPathComponent:[self configFileName]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            return filePath;
        } else {
            return nil;
        }
    }
    return nil;
}

+ (NSString *)configDirectory{
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *configDirectory = [documentDirectory stringByAppendingPathComponent:TMF_DEMO_ENVIRONMENT_DIRECTORY];
    if (![[NSFileManager defaultManager] fileExistsAtPath:configDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:configDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return configDirectory;
}

+ (NSArray *)configFileLists{

    NSError *error = nil;
    NSArray *list = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self configDirectory] error:&error];
    if (error) {
        NSLog(@"Environment Error: %@", error);
        return nil;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF like[c] '*.json'"];
    return [list filteredArrayUsingPredicate:predicate];
}

@end
