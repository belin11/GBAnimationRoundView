//
//  GBAnimationRoundView.h
//  扇形动画
//
//  Created by midas on 2017/6/8.
//  Copyright © 2017年 midas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBAnimationRoundView : UIView

- (instancetype)initWithCenter:(CGPoint)center radius:(CGFloat)radius bgColor:(UIColor *)bgColor repeatCount:(NSInteger)repeatCount;
- (void)startAnimaiton;
- (void)puaseAnimation;
@end
