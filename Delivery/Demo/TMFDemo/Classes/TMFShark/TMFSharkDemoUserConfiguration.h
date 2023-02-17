//
//  TMFSharkDemoUserConfiguration.h
//  TMFDemo
//
//  Created by klaudz on 7/5/2019.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 @brief 自定义网关配置
 */
@interface TMFSharkDemoUserConfiguration : NSObject

/**
 @brief 请求接口命令号码
 */
@property (class, nonatomic, strong, nullable) NSString *u_cmd;

/**
 @brief 请求接口命令号码
 */
@property (class, nonatomic, strong, nullable) NSString *u_cmdIDString;

/**
 @brief 请求头
 */
@property (class, nonatomic, strong, nullable) NSString *u_requestHeadersJSONString;

/**
 @brief 请求cookie
 */
@property (class, nonatomic, strong, nullable) NSString *u_requestCookiesJSONString;

/**
 @brief 请求参数
 */
@property (class, nonatomic, strong, nullable) NSString *u_requestQueriesString;

/**
 @brief 请求body
 */
@property (class, nonatomic, strong, nullable) NSString *u_requestDataString;

+ (void)synchronize;

@end


@interface TMFSharkEnvironmentConfiguration : NSObject

@property (class, nonatomic, copy, nullable) NSString *configFileName;

// 如果文件不存在，返回nil
@property (class, nonatomic, copy, readonly, nullable) NSString *configFilePath;

// 如果没有配置文件，返回 nil
+ (NSArray *)configFileLists;

@end


NS_ASSUME_NONNULL_END
