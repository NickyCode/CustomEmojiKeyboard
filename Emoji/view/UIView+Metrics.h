//
//  UIView+Metrics.h
//  Comprame
//
//  Created by Nic on 15/11/9.
//  Copyright © 2015年 Guangzhou Latin Internet Tech Nology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  方便的访问和设置View的属性
 */
@interface UIView (Metrics)

@property (assign, nonatomic) CGFloat	top;
@property (assign, nonatomic) CGFloat	bottom;
@property (assign, nonatomic) CGFloat	left;
@property (assign, nonatomic) CGFloat	right;

@property (assign, nonatomic) CGPoint	offset;
@property (assign, nonatomic) CGPoint	position;

@property (assign, nonatomic) CGFloat	x;
@property (assign, nonatomic) CGFloat	y;
@property (assign, nonatomic) CGFloat	w;
@property (assign, nonatomic) CGFloat	h;

@property (assign, nonatomic) CGFloat	width;
@property (assign, nonatomic) CGFloat	height;
@property (assign, nonatomic) CGSize	size;

@property (assign, nonatomic) CGFloat	centerX;
@property (assign, nonatomic) CGFloat	centerY;
@property (assign, nonatomic) CGPoint	origin;
@property (readonly, nonatomic) CGPoint	boundsCenter;

@end
