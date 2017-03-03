//
//  VerifyAccountView.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/23.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputView.h"
#import "RegisterModel.h"

@interface VerifyAccountView : UIView

@property (nonatomic, strong) RegisterModel *account;
@property (nonatomic, weak) id<VerifyDelegate>delegate;
@end
