//
//  FPFSystemEmoji.m
//  FanPink
//
//  Created by NickyWan on 2016/8/31.
//  Copyright © 2016年 Kugou. All rights reserved.
//

#import "FPFEmojiManager.h"
#import "MJExtension.h"
#import "FPFNetworkEngine.h"
#import "FPFLoginDataCenterModel.h"
#import "FPFURLMacros.h"


#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);

@interface FPFEmojiManager ()

@property (nonatomic, strong, readwrite) NSMutableArray<FPFEmoticonGroup *> *emojiSource;

@end

@implementation FPFEmojiManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _emojiSource = [NSMutableArray array];
//        [_emojiSource addObject:self.defaultEmoticons];
        [_emojiSource addObject:self.rebitEmoticons];
        
        [self getUserEmoticonListWithComplection:^{
            
        }];
    }
    return self;
}

- (FPFEmoticonGroup *)defaultEmoticons
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0x1F600; i<=0x1F64F; i++) {
        if (i < 0x1F641 || i > 0x1F644) {
            
            int sym = EMOJI_CODE_TO_SYMBOL(i);
            NSString *emoT = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
            
            FPFEmoticon *emoticon = [[FPFEmoticon alloc] init];
            emoticon.name = emoT;
            
            [array addObject:emoticon];
        }
    }
    
    FPFEmoticonGroup *emoticonGroup = [[FPFEmoticonGroup alloc] init];
    emoticonGroup.emoticons = array;
    
    return emoticonGroup;
}

- (FPFEmoticonGroup *)rebitEmoticons
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"defaultEmoticon" withExtension:@"cfg"];
    NSData *rebitConfigData = [NSData dataWithContentsOfURL:url];
    
    NSError *error = nil;
    NSDictionary *rebitConfig = [NSJSONSerialization JSONObjectWithData:rebitConfigData
                                                                options:0
                                                                  error:&error];
    
    if (!error) {
        
        NSMutableArray *group = [NSMutableArray array];

        [rebitConfig.allKeys enumerateObjectsUsingBlock:^(NSString  *key, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary *emoticonInfo = rebitConfig[key];
            
            [FPFEmoticon replacePropertyKey];
            FPFEmoticon *emoticon = [FPFEmoticon mj_objectWithKeyValues:emoticonInfo];
            NSURL *path = [[NSBundle mainBundle] URLForResource:key withExtension:@"png"];
            emoticon.path = path;
            [group addObject:emoticon];
        }];
        
        FPFEmoticonGroup *emoticonGroup = [[FPFEmoticonGroup alloc] init];
        
        emoticonGroup.emoticons = [group sortedArrayUsingComparator:^NSComparisonResult(FPFEmoticon * _Nonnull obj1, FPFEmoticon * _Nonnull obj2) {
            return obj1.sort - obj2.sort;
        }];
        
        return emoticonGroup;
    }
    
    return nil;
}

- (void)getUserEmoticonListWithComplection:(dispatch_block_t)complection
{
    NSString *sign = [[FPFLoginDataCenterModel sharedInstance] sign];
    
    if (!sign) {
        return;
    }
    
    NSDictionary *params = @{@"sign" : sign};
    
    __weak typeof(self) wself = self;
    
    FPFResponseFail fail = ^(NSError * _Nonnull error) {
        

    };
    
    FPFResponseSuccess success = ^(id  _Nullable response) {
        NSDictionary *data = response[@"data"];
        if (data && [data isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *sources = [NSMutableArray arrayWithCapacity:data.count];
            [FPFEmoticonGroup replacePropertyKey];
            
            [(NSArray *)data enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
                FPFEmoticonGroup *group = [FPFEmoticonGroup mj_objectWithKeyValues:obj];
                [sources addObject:group];
            }];
        }
    };
    
    FPFNetworkEngine *engine = [FPFNetworkEngine shareInstance];
    
    [engine getWithUrl:Emoticon_GetList
                params:params
               success:success
                  fail:fail];
}

@end
