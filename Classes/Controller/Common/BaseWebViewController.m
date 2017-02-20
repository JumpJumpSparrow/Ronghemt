//
//  BaseWebViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "BaseWebViewController.h"
#import "MCFNetworkManager.h"
@interface BaseWebViewController ()<UIWebViewDelegate>

@property (nonatomic, copy) NSString *url;
@end

@implementation BaseWebViewController

- (UIWebView *)contentWebView {
    if (_contentWebView == nil) {
        _contentWebView = [[UIWebView alloc] init];
        _contentWebView.delegate = self;
    }
    return _contentWebView;
}

- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.contentWebView];
    if (self.url.length > 0) [self loadRequest:self.url];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.contentWebView.frame = self.view.bounds;
}

- (void)loadRequest:(NSString *)url {
    if (url.length == 0) return;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.contentWebView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSString *requestUrl = [request URL].absoluteString;
    NSLog(@"start request :%@",requestUrl);
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
