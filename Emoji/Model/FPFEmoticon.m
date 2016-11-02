//
//  FPFEmoticon.m
//  FanPink
//
//  Created by NickyWan on 16/9/1.
//  Copyright © 2016年 Kugou. All rights reserved.
//

#import "FPFEmoticon.h"
#import "MJExtension.h"

@implementation FPFEmoticon

+ (void)replacePropertyKey
{
    [self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"emoctionid" : @"id",
                 @"groupid"    : @"e_id",
                 @"md5"        : @"md5_code",
                 @"createTime" : @"add_time"};
    }];
}

@end
