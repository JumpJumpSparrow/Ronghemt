//
//  ImageGrideView.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/24.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "ImageGridView.h"

CGFloat const kmargin           = 10.0f;
CGFloat const kinterval         = 5.0f;
NSInteger const kcolumn         = 4.0f;


@interface KImageItemButton : UIButton

@property (nonatomic, strong) UIImage *displayImage;
@property (nonatomic, strong) UIButton *cornerButton;
@property (nonatomic) SEL didSelectCorner;
@end

@implementation KImageItemButton

- (void)setDisplayImage:(UIImage *)displayImage {
    _displayImage = displayImage;
    [self setImage:displayImage forState:UIControlStateNormal];
}

- (UIButton *)cornerButton {
    if (_cornerButton == nil) {
        _cornerButton = [[UIButton alloc] init];
        [_cornerButton setImage:[UIImage imageNamed:@"deleteicon"] forState:UIControlStateNormal];
    }
    return _cornerButton;
}

- (instancetype)init {
    self = [super init];
    [self addSubview:self.cornerButton];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.cornerButton.frame = CGRectMake(self.bounds.size.width - 25.0f, 0, 25.0f, 25.0f);
}

@end


@interface ImageGridView ()

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSMutableArray *itemArray;
@end

@implementation ImageGridView

- (UIButton *)addButton {
    if (_addButton == nil) {
        _addButton = [[UIButton alloc] init];
        [_addButton setImage:[UIImage imageNamed:@"selectPhoto"] forState:UIControlStateNormal];
        _addButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_addButton addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    CGFloat width = (frame.size.width - kmargin * 2 - (kinterval * (kcolumn - 1)))/kcolumn;
    frame.size.height = width + kmargin * 2;
    self = [super initWithFrame:frame];
    self.itemArray = [NSMutableArray arrayWithCapacity:0];
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.addButton];
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self loadImages:nil];
}

- (void)addImage {
    if ([self.delegate respondsToSelector:@selector(imageGrideDidSelectAddImageButton)]) {
        [self.delegate imageGrideDidSelectAddImageButton];
    }
}

- (void)loadImages:(NSArray *)images {
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.itemArray removeAllObjects];
    
    [self addSubview:self.addButton];
    
    self.imageArray = images;
    int index = 0;
    for (UIImage *image in images) {
        KImageItemButton *item = [[KImageItemButton alloc] init];
        item.displayImage = image;
        item.cornerButton.tag = index;
        index ++;
        [item.cornerButton addTarget:self action:@selector(didSelectIconButton:) forControlEvents:UIControlEventTouchUpInside];
        [item addTarget:self action:@selector(didSelectDisplyButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.itemArray addObject:item];
        [self addSubview:item];
    }
    // 添加按钮
    NSInteger row = floor((float)images.count / (float)kcolumn);
    CGFloat width = (self.bounds.size.width - kmargin * 2 - (kinterval * (kcolumn - 1)))/kcolumn;
    CGRect frame =  self.frame;
    frame.size.height = width * (row + 1) + row*kinterval + kmargin * 2;
    self.frame = frame;
}

- (void)didSelectIconButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(deletSelectedItemAtIndex:)]) {
        [self.delegate deletSelectedItemAtIndex:sender.tag];
    }
}

- (void)didSelectDisplyButton:(KImageItemButton *)sender {
    if ([self.delegate respondsToSelector:@selector(displySelectedImage:)]) {
        [self.delegate displySelectedImage:sender.displayImage];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger count = self.imageArray.count;
    CGFloat width = (self.bounds.size.width - kmargin * 2 - (kinterval * (kcolumn - 1)))/kcolumn;
    for (int i = 0 ; i < count; i++) {
        NSInteger row = i / kcolumn;
        NSInteger col = (int)i % (int)kcolumn;
        
        KImageItemButton *item = [self.itemArray objectAtIndex:i];
        item.frame = CGRectMake(col * (width + kinterval) + kmargin , row * (width + kinterval) + kmargin, width, width);
    }
    
    NSInteger row = floor((float)count / kcolumn);
    NSInteger col = (int)count % (int)kcolumn;
    self.addButton.frame = CGRectMake(col * (width + kinterval) + kmargin , row * (width + kinterval) + kmargin, width, width);
    self.addButton.hidden = self.limitCount == self.imageArray.count;
}

@end
