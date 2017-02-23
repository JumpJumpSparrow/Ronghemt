//
//  BaseViewController.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/16.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit.h>
#import "MCFTools.h"
@interface BaseViewController : UIViewController

- (void)showTip:(NSString *)tip;

- (void)showLoading;
- (void)hideLoading;
@end
