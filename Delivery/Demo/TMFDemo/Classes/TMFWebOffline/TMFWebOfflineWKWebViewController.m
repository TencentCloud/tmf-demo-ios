//
//  TMFWebOfflineWKWebViewController.m
//  TMFDemo
//
//  Created by klaudz on 20/4/2019.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "TMFWebOfflineWKWebViewController.h"
#import "TMFWebOfflineService.h"
#import "TMFWebOfflineHandler.h"

#import "TMFWebOfflineWebViewDebugLogViewController.h"

#import "NSURL+MQQExtended.h"

@interface TMFWebOfflineWKWebViewController () <WKNavigationDelegate, WKUIDelegate, TMFWebOfflineWebViewControllerProtocol>

@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) TMFWkWebView *webView;

@end

@implementation TMFWebOfflineWKWebViewController

@synthesize tmf_webOfflineHandler = _tmf_webOfflineHandler;

- (instancetype)initWithURL:(NSURL *)URL {
    self = [super init];
    if (self) {
        self.URL = URL;
        self.tmf_webOfflineHandler = [[TMFWebOfflineHandler alloc] initWithWebViewController:self];

        self.title = @"TMFWebOffline Demo";
    }
    return self;
}

- (void)dealloc {
    self.webView.navigationDelegate = nil;
    self.webView.UIDelegate = nil;

    [self.tmf_webOfflineHandler clearWebViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"调试日志" style:UIBarButtonItemStylePlain target:self
                                                                          action:@selector(debugButtonClicked:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

//    TMFWkWebView *webView = [[TMFWkWebView alloc] initWithFrame:self.view.frame];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    TMFWkWebView *webView = [[TMFWkWebView alloc] initWithFrame:self.view.frame configuration:config];
    
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    self.webView = webView;
    [self.view addSubview:self.webView];

    NSURL *determinedURL = [self.tmf_webOfflineHandler
        determinedURLWithURL:self.URL];  // 由 WebOffline Handler 来决定最终要访问的 URL，例如开启 fallback 功能，此处会对 URL 进行转换
    NSURLRequest *request = [NSURLRequest requestWithURL:determinedURL];
    [self.webView loadRequest:request];
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark -

- (NSURL *)overCacheURLWithURL:(NSURL *)URL {
    NSString *timestamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *const queryName = @"_t";
    NSURL *overCacheURL = [URL mqqURLByDeletingQueryNames:@[queryName]];
    overCacheURL = [overCacheURL mqqURLByAppendingQueryComponentDictionary:@{ queryName: timestamp }];
    return overCacheURL;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView
    decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
                    decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // Handle the WebOfflineHandler
    [self.tmf_webOfflineHandler handleRequest:navigationAction.request];

    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
}

#pragma mark - TMFWebOfflineWebViewControllerProtocol

- (UIView *)tmf_webView {
    return self.webView;
}

#pragma mark - Debug

- (void)debugButtonClicked:(UIBarButtonItem *)barButtonItem {
    TMFWebOfflineWebViewDebugLogViewController *viewController = [[TMFWebOfflineWebViewDebugLogViewController alloc] init];

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [array addObject:[TMFWebOfflineService getWebLogDic]];
    [array addObject:[TMFWebOfflineService getStartLogDic]];
    [array addObject:[TMFWebOfflineService getPluginLogDic]];
    [array addObject:[TMFWebOfflineService getOfflineLogDic]];

    viewController.sourceArray = array;
    viewController.sumLog = [TMFWebOfflineService getWebviewSumLog];
#pragma clang diagnostic pop

    [self.navigationController pushViewController:viewController animated:YES];
}

@end
