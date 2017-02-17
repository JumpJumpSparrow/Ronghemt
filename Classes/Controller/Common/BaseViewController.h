//
//  BaseViewController.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/16.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit.h>
@interface BaseViewController : UIViewController


- (void)showLoading;
- (void)hideLoading;
- (void)showTip:(NSString *)tip;
@end
