//
//  FPFSystemEmoji.h
//  FanPink
//
//  Created by NickyWan on 2016/8/31.
//  Copyright © 2016年 Kugou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPFEmoticonGroup.h"

@interface FPFEmojiManager : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<FPFEmoticonGroup *> *emojiSource;

@end
