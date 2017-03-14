//
//  BreakNews.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/13.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "BreakNews.h"

@implementation BreakNews

- (NSString *)photo1 {
    
    if (_photo1.length == 0) {
        return @"";
    }
    NSMutableString *photo = [[NSMutableString alloc] initWithString:_photo1];
    if (_photo2.length > 0) {
        [photo appendString:@","];
        [photo appendString:_photo2];
    }
    if (_photo3.length > 0) {
        [photo appendString:@","];
        [photo appendString:_photo3];
    }
    return photo;
}

@end
