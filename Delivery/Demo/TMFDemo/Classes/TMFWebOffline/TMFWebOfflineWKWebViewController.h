//
//  TMFWebOfflineWKWebViewController.h
//  TMFDemo
//
//  Created by klaudz on 20/4/2019.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "QDCommonViewController.h"
#import <WebKit/WebKit.h>
#import "TMFWkWebView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMFWebOfflineWKWebViewController : QDCommonViewController

@property (nonatomic, strong, readonly) TMFWkWebView *webView;

- (instancetype)initWithURL:(NSURL *)URL;

@end

NS_ASSUME_NONNULL_END
