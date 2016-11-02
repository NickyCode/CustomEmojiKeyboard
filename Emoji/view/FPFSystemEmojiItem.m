//
//  FPFSystemEmojiItem.m
//  FanPink
//
//  Created by NickyWan on 2016/8/31.
//  Copyright © 2016年 Kugou. All rights reserved.
//

#import "FPFSystemEmojiItem.h"

@implementation FPFSystemEmojiItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _btn = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_btn];
        _btn.titleLabel.font = [UIFont systemFontOfSize:30];
        [_btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)btnAction:(UIButton *)btn
{
    if (_selectedEmoji) {
        self.selectedEmoji();
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _btn.frame = CGRectMake(-5, -5, 40, 40);
}

@end
