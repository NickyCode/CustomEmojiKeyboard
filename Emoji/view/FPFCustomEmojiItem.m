//
//  FPFCustomEmojiItem.m
//  FanPink
//
//  Created by NickyWan on 2016/8/31.
//  Copyright © 2016年 Kugou. All rights reserved.
//

#import "FPFCustomEmojiItem.h"

@implementation FPFCustomEmojiItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _btn = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_btn];
        
        _btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _nameLabel = [[UILabel alloc] init];
        [self addSubview:_nameLabel];
        
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor colorWithHexString:@"#8d8d8d"];
        _nameLabel.font = [UIFont systemFontOfSize:12];
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
    _btn.frame = self.bounds;
    _btn.height -= 22;

    _nameLabel.frame = CGRectMake(0, _btn.bottom, self.width, 22);
}

@end
