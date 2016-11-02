//
//  FPFEmojiBarItem.m
//  FanPink
//
//  Created by NickyWan on 16/8/31.
//  Copyright © 2016年 Kugou. All rights reserved.
//

#import "FPFEmojiBarItem.h"

@implementation FPFEmojiBarItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageview = [[UIImageView alloc] init];
        _imageView = imageview;
        [self addSubview:_imageView];
        
        imageview.contentMode = UIViewContentModeCenter;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}

@end
