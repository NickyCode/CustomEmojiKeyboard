//
//  FPFEmojiItemLayout.h
//  FanPink
//
//  Created by NickyWan on 16/8/31.
//  Copyright © 2016年 Kugou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPFEmojiItemLayout : UICollectionViewFlowLayout

@property (nonatomic, strong, readonly) NSMutableDictionary *pageIndexOfSections;

@property (nonatomic, strong, readonly) NSMutableDictionary *numOfPageInSections;

@end
