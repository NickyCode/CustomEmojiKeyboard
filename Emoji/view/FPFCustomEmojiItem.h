//
//  FPFCustomEmojiItem.h
//  FanPink
//
//  Created by NickyWan on 2016/8/31.
//  Copyright © 2016年 Kugou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPFCustomEmojiItem : UICollectionViewCell
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, copy) void(^selectedEmoji)(void);
@end
