//
//  ProfileViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/21.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "ProfileViewController.h"
#import "MCFUserModel.h"
#import "MCFPhotoKit.h"
#import "BindPhoneViewController.h"
#import "MCFNetworkManager+User.h"
#import <YYKit.h>

@interface TitleInputProfileView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) UIReturnKeyType returnType;
@property (nonatomic, assign) NSInteger lengthLimit;

- (instancetype)initWith:(NSString *)title placeholder:(NSString *)holder frame:(CGRect)frame;
@end

@implementation TitleInputProfileView

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"昵称";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _titleLabel;
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

- (void)setReturnType:(UIReturnKeyType)returnType {
    self.inputField.returnKeyType = returnType;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    self.inputField.keyboardType = keyboardType;
}

- (instancetype)initWith:(NSString *)title placeholder:(NSString *)holder frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self addSubview:self.titleLabel];
    [self addSubview:self.inputField];
    self.titleLabel.text = title;
    self.inputField.placeholder = holder;
    self.lengthLimit = 20;
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (toBeString.length > self.lengthLimit) {
        return NO;
    }
    return YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.width/4.0f;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.titleLabel.width/2.0f + 10, self.height/2.0f);
    
    self.inputField.frame = CGRectMake(0, 0, width * 3 - 40.0f, 30);
    self.inputField.center = CGPointMake(width * 3 - 40.0f, self.height/2.0f);
}

@end

@interface AvatarButton : UIButton

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation AvatarButton

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel  = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
        _nameLabel.text = @"修改头像";
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}

- (UIImageView *)avatarView {
    if (_avatarView == nil) {
        _avatarView  = [[UIImageView alloc] init];
    }
    return _avatarView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self addSubview:self.avatarView];
    self.avatarView.clipsToBounds = YES;
    self.avatarView.image = [UIImage imageNamed:@"defaultAvatar"];
    [self addSubview:self.nameLabel];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.avatarView.frame = CGRectMake(0, 0, 50.0f, 50.0f);
    self.avatarView.layer.cornerRadius  = 25.0f;
    self.avatarView.center = CGPointMake(self.avatarView.width/2.0f + 10, self.height/2.0f);
    [self.nameLabel sizeToFit];
    self.nameLabel.frame = CGRectMake(self.avatarView.right + 10, self.height/2.0f - self.nameLabel.height/2.0f, self.nameLabel.width, self.nameLabel.height);
}

@end

@interface TitleButton : UIButton

@property (nonatomic, strong) UILabel *mainTitleLabel;
@property (nonatomic, strong) UILabel *subTilteLabel;
@property (nonatomic, strong) UIImageView *accessoryView;
@end

@implementation TitleButton

- (UILabel *)mainTitleLabel {
    if (_mainTitleLabel == nil) {
        _mainTitleLabel  = [[UILabel alloc] init];
        _mainTitleLabel.font = [UIFont systemFontOfSize:15.0f];
        _mainTitleLabel.text = @"绑定手机号";
        _mainTitleLabel.textColor = [UIColor blackColor];
    }
    return _mainTitleLabel;
}

- (UILabel *)subTilteLabel {
    if (_subTilteLabel == nil) {
        _subTilteLabel = [[UILabel alloc] init];
        _subTilteLabel.textColor = [UIColor colorWithHexString:AppColorNormal];
        _subTilteLabel.font = [UIFont systemFontOfSize:15.0f];
        _subTilteLabel.text = @"182****9238";
    }
    return _subTilteLabel;
}

- (UIImageView *)accessoryView {
    if (_accessoryView == nil) {
        _accessoryView = [[UIImageView alloc] init];
    }
    return _accessoryView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self addSubview:self.mainTitleLabel];
    [self addSubview:self.subTilteLabel];
    [self addSubview:self.accessoryView];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.width/4.0f;
    
    [self.mainTitleLabel sizeToFit];
    self.mainTitleLabel.center = CGPointMake(self.mainTitleLabel.width/2.0f + 10.0f, self.height/2.0f);
    self.subTilteLabel.frame = CGRectMake(0,0, width * 3 - 40, 40);
    self.subTilteLabel.center = CGPointMake(width * 3 - 40.0f, self.height / 2.0f);
}

@end

@interface ProfileViewController ()<UITextFieldDelegate, CameraDataDelegate, MCFPhotoDelegate>

@property (nonatomic, strong) MCFUserModel *user;
@property (nonatomic, strong) AvatarButton *avatarButton;
@property (nonatomic, strong) TitleInputProfileView *inputNameView;
@property (nonatomic, strong) TitleButton *phoneButton;
@property (nonatomic, strong) UIButton *rightButton;
@end

@implementation ProfileViewController

- (AvatarButton *)avatarButton {
    if (_avatarButton == nil) {
        _avatarButton = [[AvatarButton alloc] initWithFrame:CGRectMake(0, 64.0f + 10.0f, SCREEN_WIDTH, 100)];
        [_avatarButton.avatarView setImageURL:[NSURL URLWithString:[MCFTools getLoginUser].avatar]];
        [_avatarButton addTarget:self action:@selector(didSelectAvatarButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarButton;
}

- (TitleInputProfileView *)inputNameView {
    if (_inputNameView == nil) {
        MCFUserModel *user = [MCFTools getLoginUser];
        NSString *placeHolder = user.username;
        if (placeHolder.length == 0) {
            placeHolder = [MCFTools securityText:user.phone];
        }
        _inputNameView = [[TitleInputProfileView alloc] initWith:@"昵称" placeholder:placeHolder frame:CGRectMake(0, self.avatarButton.bottom + 10, SCREEN_WIDTH, 50)];
        _inputNameView.inputField.delegate = self;
        _inputNameView.lengthLimit = 10;
    }
    return _inputNameView;
}

- (TitleButton *)phoneButton {
    if (_phoneButton == nil) {
        _phoneButton = [[TitleButton alloc] initWithFrame:CGRectMake(0, self.inputNameView.bottom + 10, SCREEN_WIDTH, 50)];
        [_phoneButton addTarget:self action:@selector(didSelectTitlebutton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneButton;
}

- (instancetype)initWithUser:(MCFUserModel *)user {
    self = [super init];
    self.user = user;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = APPGRAY;
    self.title = @"修改资料";
    [self.view addSubview:self.avatarButton];
    [self.view addSubview:self.inputNameView];
    [self.view addSubview:self.phoneButton];
    self.avatarButton.backgroundColor = [UIColor whiteColor];
    self.inputNameView.backgroundColor  = [UIColor whiteColor];
    self.phoneButton.backgroundColor = [UIColor whiteColor];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor colorWithHexString:AppColorSelected] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor colorWithHexString:AppColorNormal] forState:UIControlStateDisabled];
    [self.rightButton sizeToFit];
    self.rightButton.enabled = NO;
    [self.rightButton addTarget:self action:@selector(didSelectDone) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didSelectDone {

    MCFUserModel *user = [MCFTools getLoginUser];
    user.username = self.inputNameView.inputField.text;
    [self updateUser:user];
}

- (void)updateUser:(MCFUserModel *)user {
    [self showLoading];
    [MCFTools saveLoginUser:user];
    [MCFNetworkManager updateUserProfile:user success:^(NSString *tip) {
        [self hideLoading];
        [self showTip:tip];
    } failure:^(NSError *error) {
        [self hideLoading];
        [self showTip:@"网络错误"];
    }];
}

#pragma mark - cameraDelegate

- (void)cameraDidSelectImage:(UIImage *)image {
    [self showLoading];
    [MCFNetworkManager uploadFile:image success:^(NSString *url) {
        [self hideLoading];
        MCFUserModel *user = [MCFTools getLoginUser];
        user.photo = url;
        [self updateUser:user];
    } failure:^(NSError *error) {
        [self hideLoading];
    }];
}

- (void)MCFPhotoLibraryDidSelectImages:(NSArray *)images {
    UIImage *image = (UIImage *)[images firstObject];
    [self cameraDidSelectImage:image];
}

- (void)didSelectAvatarButton {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择照片源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MCFCameraViewController *cameraVC = [[MCFCameraViewController alloc] init];
        cameraVC.delegate = self;
        cameraVC.isCropView = YES;
        [self.navigationController pushViewController:cameraVC animated:YES];
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MCFPhotoLibraryViewController *photoVC = [[MCFPhotoLibraryViewController alloc] init];
        photoVC.selectImageToCrop = YES;
        photoVC.delegate = self;
        [self.navigationController pushViewController:photoVC animated:YES];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cameraAction];
    [alertController addAction:photoAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:NULL];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    self.rightButton.enabled = textField.text.length > 0;
    
    return YES;
}

- (void)didSelectTitlebutton {
    BindPhoneViewController *bindPhoneVc = [[BindPhoneViewController alloc] init];
    [self.navigationController pushViewController:bindPhoneVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

@end
