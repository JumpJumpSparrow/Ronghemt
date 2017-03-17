//
//  ThirdLogInView.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/17.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ThirdLogInDelegate <NSObject>

- (void)didSelectLoginMethod:(NSInteger)index;
@end

@interface ThirdLogInView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSArray *buttonList;
@property (nonatomic, weak) id <ThirdLogInDelegate>delegate;
@end
