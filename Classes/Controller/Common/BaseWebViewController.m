//
//  BaseWebViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "BaseWebViewController.h"
#import "MCFNetworkManager.h"
#import "MCFNetworkManager+User.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "AppDelegate.h"
#import "MCFTools.h"
#import "MCFUserModel.h"
#import "BreakingNewsViewController.h"
#import "CommentBar.h"
#import "CommentViewController.h"
#import "CommentListViewController.h"
#import "ShareViewController.h"
#import <MJRefresh.h>
#import "MCFShareUtil.h"
#import "LogInViewController.h"

@interface BaseWebViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, CommentBarDelegate>

@property (nonatomic, assign) dispatch_once_t onceToken;
@property (nonatomic, strong) WKWebViewConfiguration *configuration;
@property (nonatomic, strong) CommentBar *commentBar;
@property (nonatomic, strong) NSDictionary *currentPageInfo;
@end

@implementation BaseWebViewController

- (CommentBar *)commentBar {
    if (_commentBar == nil) {
        _commentBar = [[CommentBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 55.0f, SCREEN_WIDTH, 55.0f)];
        _commentBar.delegate = self;
    }
    return _commentBar;
}

- (WKWebViewConfiguration *)configuration {
    if (_configuration == nil) {
        _configuration = [[WKWebViewConfiguration alloc] init];
        [_configuration.userContentController addScriptMessageHandler:self name:@"goDetail"];
        [_configuration.userContentController addScriptMessageHandler:self name:@"goToBaoLiao"];
        [_configuration.userContentController addScriptMessageHandler:self name:@"goNavigationDetail"];
        [_configuration.userContentController addScriptMessageHandler:self name:@"switchPages"];
        [_configuration.userContentController addScriptMessageHandler:self name:@"goToMoreProgram"];
        [_configuration.userContentController addScriptMessageHandler:self name:@"goBack"];
        [_configuration.userContentController addScriptMessageHandler:self name:@"getValue"];
        [_configuration.userContentController addScriptMessageHandler:self name:@"getJs"];
    }
    return _configuration;
}

- (WKWebView *)contentWebView {
    if (_contentWebView == nil) {

        _contentWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.configuration];
        _contentWebView.UIDelegate = self;
        _contentWebView.navigationDelegate = self;
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
    if(self.showCommentBar){
        [self.view addSubview:self.commentBar];
    }
    
    self.contentWebView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadUrl:self.url];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.hideNavi) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    if (self.showCommentBar) {
        [self.contentWebView.scrollView addObserver:self
                                         forKeyPath:@"contentOffset"
                                            options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                                            context:nil];
    }
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.contentWebView.frame = self.view.bounds;
    dispatch_once(&_onceToken, ^{
        if (self.url.length > 0) [self loadUrl:self.url];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if (self.showCommentBar) {
        [self.contentWebView.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    [super viewWillDisappear:animated];
}

- (void)loadUrl:(NSString *)url {
    if (url.length == 0) return;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.contentWebView loadRequest:request];
}


- (NSDictionary *)getDictionaryWithJsonString:(NSString *)json {
    if (json.length == 0) return nil;
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) return nil;
    return dict;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (self.showCommentBar) {
        CGPoint newPoint = [[change objectForKey:@"new"] CGPointValue];
        CGRect frame = self.commentBar.frame;
        if (newPoint.y > 100) { // up
            if (frame.origin.y < SCREEN_HEIGHT) {
                frame.origin.y = SCREEN_HEIGHT + 10.0f;
                [UIView animateWithDuration:0.5 animations:^{
                    self.commentBar.frame = frame;
                }];
            }
        } else {
            if (frame.origin.y > SCREEN_HEIGHT) {
                frame.origin.y = SCREEN_HEIGHT - 55.0f;
                [UIView animateWithDuration:0.5 animations:^{
                    self.commentBar.frame = frame;
                }];
            }
        }
    }
    NSLog(@"%@",change);
}

#pragma mark - CommentBarDelegate

- (void)didSelectCommentIndex:(UIButton *)sender {
    
    if (![MCFTools isLogined]) {
        
        LogInViewController *loginVC = [[LogInViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    if (sender.tag == 0 && self.currentPageInfo != nil) {
        CommentViewController *commentVC = [[CommentViewController alloc] initWithDict:self.currentPageInfo];
        commentVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:commentVC animated:YES];
    } else if (sender.tag == 2) {
        if(sender.selected) {
            [self removeCollect];
        } else {
            [self collectItem];
        }
    } else if (sender.tag == 1) {
        NSInteger globaleID = [self.currentPageInfo[@"globalId"] integerValue];
        CommentListViewController *commentListVC = [[CommentListViewController alloc] initWithGlobalId:globaleID];
        commentListVC.hidesBottomBarWhenPushed = YES;
        commentListVC.title = @"所有评论";
        [self.navigationController pushViewController:commentListVC animated:YES];
    } else if (sender.tag == 3){
        NSString *url = self.currentPageInfo[@"loadUrl"];
        [MCFShareUtil showShareMenuToShareUrl:url];
    }
}

- (void)collectItem {
    [self showLoading];
    [MCFNetworkManager collectItem:self.currentPageInfo
                           success:^(NSString *tip) {
        [self hideLoading];
        [self showTip:@"收藏成功"];
    } failure:^(NSError *error) {
        [self hideLoading];
        [self showTip:@"请求失败"];
    }];
}

- (void)removeCollect {
    [self showLoading];
    [MCFNetworkManager removeCollectItem:self.currentPageInfo
                                 success:^(NSString *tip) {
        [self hideLoading];
        [self showTip:@"已移除收藏"];
    } failure:^(NSError *error) {
        [self hideLoading];
        [self showTip:@"请求失败"];
    }];
}

#pragma mark - WKWebViewDelegate

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%@ == %@", message.name, message.body);
    
    NSDictionary *dict = message.body;
    if (dict == nil) return;
    
    if ([message.name isEqualToString:@"goDetail"]) {
        NSString *url = dict[@"loadUrl"];
        BaseWebViewController *webVC = [[BaseWebViewController alloc] initWithUrl:url];
        webVC.showCommentBar = YES;
        webVC.hideNavi = YES;
        webVC.showBarCover = YES;
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    if ([message.name isEqualToString:@"goNavigationDetail"]) {
        NSString *url = dict[@"loadUrl"];
        NSString *title = dict[@"title"];
        BaseWebViewController *webVC = [[BaseWebViewController alloc] initWithUrl:url];
        webVC.hidesBottomBarWhenPushed = YES;
        webVC.hideNavi = title.length == 0;
        webVC.showBarCover = title.length == 0;
        webVC.title = title;

        [self.navigationController pushViewController:webVC animated:YES];
    }
    if ([message.name isEqualToString:@"switchPages"]) {
        NSInteger index = [dict[@"firstMenu"] integerValue];
        NSInteger subIndex = [dict[@"secMenu"] integerValue];
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.rootVc switchToIndex:index subIndex:subIndex];
    }
    
    if ([message.name isEqualToString:@"goToBaoLiao"]) {
        
        BreakingNewsViewController *breakVC = [[BreakingNewsViewController alloc] init];
        breakVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:breakVC animated:YES];
    }
    if ([message.name isEqualToString:@"getValue"]) {
        [self callBackJS];
    }
   
    if ([message.name isEqualToString:@"goToMoreProgram"]){
        NSString *url = dict[@"loadUrl"];
        BaseWebViewController *webVC = [[BaseWebViewController alloc] initWithUrl:url];
        webVC.hidesBottomBarWhenPushed = YES;
        webVC.showCommentBar = YES;
        webVC.hideNavi = YES;
        webVC.showBarCover = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    if ([message.name isEqualToString:@"goBack"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([message.name isEqualToString:@"getJs"]) {
        self.currentPageInfo = dict;
        [self checkCollectStatus];
    }
}

- (void)checkCollectStatus {
    [MCFNetworkManager checkHasCollectedItem:self.currentPageInfo
                                     success:^(BOOL isCollected) {
                                         [self.commentBar setCollectButtonSellected:isCollected];
    } failure:^(NSError *error) {
        
    }];
}

- (void)callBackJS {
    MCFUserModel *user = [MCFTools getLoginUser];
    NSString *jsFunc = @"getSessionId(\"%@\");";
    NSString *jsCode = [NSString stringWithFormat:jsFunc,user.session];
    [self.contentWebView evaluateJavaScript:jsCode completionHandler:NULL];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self showLoading];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self hideLoading];
    [self.contentWebView.scrollView.mj_header endRefreshing];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self hideLoading];
    [self.contentWebView.scrollView.mj_header endRefreshing];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
    NSLog(@"网页加载链接===%@", navigationAction.request.URL.absoluteString);
}

// realese the delegate here! to do 
- (void)dealloc {
    NSLog(@"内存泄露问题解决了");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
