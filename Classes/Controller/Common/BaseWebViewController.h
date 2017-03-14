//
//  BaseWebViewController.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface BaseWebViewController : BaseViewController

@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) WKWebView *contentWebView;
@property (nonatomic, assign) BOOL hideNavi;

- (void)loadUrl:(NSString *)url;
- (instancetype)initWithUrl:(NSString *)url;
@end
