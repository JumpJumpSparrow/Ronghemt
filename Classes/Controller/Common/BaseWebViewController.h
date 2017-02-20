//
//  BaseWebViewController.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseWebViewController : BaseViewController

@property (nonatomic, strong) UIWebView *contentWebView;

- (void)loadRequest:(NSString *)url;
- (instancetype)initWithUrl:(NSString *)url;
@end
