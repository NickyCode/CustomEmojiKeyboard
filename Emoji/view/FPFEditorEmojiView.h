//
//  FPFEditorEmojiView.h
//  FanPink
//
//  Created by NickyWan on 16/7/20.
//  Copyright © 2016年 Kugou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPFEmoticon.h"

@protocol FPFEditorEmojiViewDelegate;

@interface FPFEditorEmojiView : UIView

@property (nonatomic, weak) id<FPFEditorEmojiViewDelegate> delegate;

- (instancetype)initWithRootView:(UIView *)rootView;

@end

@protocol FPFEditorEmojiViewDelegate <NSObject>
@required
- (void)emojiView:(FPFEditorEmojiView *)emojiView didSelectedEmoticon:(FPFEmoticon *)emotion;
- (void)emojiView:(FPFEditorEmojiView *)emojiView didClearEmoticon:(FPFEmoticon *)emotion;

@end
