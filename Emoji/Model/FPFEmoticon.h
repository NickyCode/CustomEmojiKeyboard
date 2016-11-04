//
//  FPFEmoticon.h
//  FanPink
//
//  Created by NickyWan on 16/9/1.
//  Copyright © 2016年 Kugou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPFEmoticon : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *emoticonid;
@property (nonatomic, copy) NSString *groupid;
@property (nonatomic, copy) NSString *md5;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSURL *path;

@end
