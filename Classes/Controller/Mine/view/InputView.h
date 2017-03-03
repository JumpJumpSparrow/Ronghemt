//
//  InputView.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/23.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit/UIView+YYAdd.h>

@protocol VerifyDelegate <NSObject>

@optional
- (void)verifyTheAccount;
- (void)didInputText:(NSString *)text index:(NSInteger)index;
@end
@interface InputView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *verifyButton;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) CALayer *line;
@property (nonatomic, strong) CALayer *verticalLine;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) UIReturnKeyType returnType;
@property (nonatomic, assign) BOOL isSecureText;
@property (nonatomic, assign) BOOL isVerify;
@property (nonatomic, assign) NSInteger lengthLimit;
@property (nonatomic, weak) id<VerifyDelegate> delegate;
@property (nonatomic, assign) NSInteger index;

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)holder;
@end
