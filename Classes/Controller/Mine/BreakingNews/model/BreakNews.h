//
//  BreakNews.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/13.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFBaseModel.h"

@interface BreakNews : MCFBaseModel

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *contentID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *Status;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *photo1;
@property (nonatomic, copy) NSString *photo2;
@property (nonatomic, copy) NSString *photo3;
@property (nonatomic, copy) NSString *video;
@property (nonatomic, copy) NSString *content;
@end
