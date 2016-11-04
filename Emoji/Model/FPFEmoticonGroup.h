//
//  FPFEmoticonGroup.h
//  FanPink
//
//  Created by NickyWan on 16/9/1.
//  Copyright © 2016年 Kugou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPFEmoticon.h"

@interface FPFEmoticonGroup : NSObject

@property (nonatomic, copy) NSString *groupid;
@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *md5;
@property (nonatomic, strong) NSURL *iconURL;
@property (nonatomic, strong) NSURL *packageURL;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, strong) NSArray<FPFEmoticon *> *emoticons;


@end
