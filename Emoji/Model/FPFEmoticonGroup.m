//
//  FPFEmoticonGroup.m
//  FanPink
//
//  Created by NickyWan on 16/9/1.
//  Copyright © 2016年 Kugou. All rights reserved.
//

#import "FPFEmoticonGroup.h"
#import "MJExtension.h"

@implementation FPFEmoticonGroup

+ (void)replacePropertyKey
{
    [self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"groupid"     : @"ID",
                 @"appid"       : @"AID",
                 @"name"        : @"N",
                 @"fileName"    : @"PN",
                 @"iconURL"     : @"IC",
                 @"packageURL"  : @"F",
                 @"type"        : @"TP",
                 @"price"       : @"PC",
                 @"sort"        : @"SO",
                 @"state"       : @"ST",
                 @"md5"         : @"MD5",
                 @"createTime"  : @"AT"};
    }];
}

@end
