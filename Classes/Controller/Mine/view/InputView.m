//
//  InputView.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/23.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "InputView.h"

@implementation InputView

- (UIButton *)verifyButton {
    if (_verifyButton == nil) {
        _verifyButton = [[UIButton alloc] init];
        [_verifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_verifyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_verifyButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _verifyButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_verifyButton addTarget:self action:@selector(didSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _verifyButton;
}

- (UITextField *)inputField {
    if (_inputField == nil) {
        _inputField = [[UITextField alloc] init];
        _inputField.font = [UIFont systemFontOfSize:15.0f];
        _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputField.delegate = self;
    }
    return _inputField;
}

- (CALayer *)verticalLine {
    if (_verticalLine == nil) {
        _verticalLine = [[CALayer alloc] init];
        _verticalLine.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1].CGColor;
    }
    return _verticalLine;
}

- (CALayer *)line {
    if (_line == nil) {
        _line = [[CALayer alloc] init];
        _line.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1].CGColor;
    }
    return _line;
}

- (void)setReturnType:(UIReturnKeyType)returnType {
    self.inputField.returnKeyType = returnType;
}

- (void)setIsSecureText:(BOOL)isSecureText {
    self.inputField.secureTextEntry = isSecureText;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    self.inputField.keyboardType = keyboardType;
}

- (void)setIsVerify:(BOOL)isVerify {
    _isVerify = isVerify;
    self.verifyButton.hidden =
    self.verticalLine.hidden = !isVerify;
}

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)holder {
    self = [super initWithFrame:frame];
    [self addSubview:self.verifyButton];
    [self addSubview:self.inputField];
    [self.layer addSublayer:self.line];
    [self.layer addSublayer:self.verticalLine];
    self.inputField.placeholder = holder;
    self.lengthLimit = 20;
    
    self.verticalLine.hidden =
    self.verifyButton.hidden = YES;
    return self;
}

- (void)didSelectedButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(verifyTheAccount:)]) {
        [self.delegate verifyTheAccount:sender];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSUInteger lengthOfString = toBeString.length;  //lengthOfString的值始终为1
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
        unichar character = [toBeString characterAtIndex:loopIndex];
        // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
        if (character < 48) return NO; // 48 unichar for 0
        if (character > 57 && character < 65) return NO; //
        if (character > 90 && character < 97) return NO;
        if (character > 122) return NO;
        
    }
    if (toBeString.length > self.lengthLimit) {
        return NO;
    }
    if ([self.delegate respondsToSelector:@selector(didInputText: index:)]) {
        [self.delegate didInputText:toBeString index:self.index];
    }
    return YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = (SCREEN_WIDTH / 3.0f);

    self.inputField.frame = CGRectMake(0, 0, width * 2 - 30.0f, 30);
    self.inputField.center = CGPointMake(self.inputField.width / 2.0f + 20.0f, self.height/2.0f);
    self.line.frame = CGRectMake(10, self.height - 0.5f, self.width - 20, 0.5f);
    
    if (self.isVerify) {
        self.verifyButton.frame = CGRectMake((width * 2), 0, width, self.height - 1.0f);
        self.verticalLine.frame = CGRectMake(width * 2, 5.0f, 0.5, self.height - 10.0f);
    }
}

@end
