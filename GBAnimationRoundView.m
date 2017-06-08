//
//  GBAnimationRoundView.m
//  扇形动画
//
//  Created by midas on 2017/6/8.
//  Copyright © 2017年 midas. All rights reserved.
//

#import "GBAnimationRoundView.h"

@interface GBAnimationRoundView ()

@property (nonatomic, weak) CAShapeLayer *maskLayer;

@property (nonatomic, assign) NSInteger repeatCount;

@property (nonatomic, weak) NSTimer *timer;

@end

@implementation GBAnimationRoundView

- (instancetype)initWithCenter:(CGPoint)center radius:(CGFloat)radius bgColor:(UIColor *)bgColor repeatCount:(NSInteger)repeatCount {
    if (self = [super init]) {
        
        //设置self的frame和center
        self.backgroundColor = bgColor;
        self.frame = CGRectMake(0, 0, radius * 2, radius * 2);
        self.center = center;
        
        _repeatCount = repeatCount;
        //特别注意：贝塞尔曲线的radius必须为self高度的四分之一，CAShapeLayer的线宽必须为self高度的二分之一
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius / 2 startAngle:-M_PI/2 endAngle:M_PI *3 / 2 clockwise:YES];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = path.CGPath;
        maskLayer.fillColor = [UIColor clearColor].CGColor;
        maskLayer.strokeColor = bgColor.CGColor;
        maskLayer.lineWidth = radius; //等于半径的2倍，以圆的边缘为中心，向圆内部伸展一个半径，向外伸展一个半径，所以看上去以为圆的半径是self高度的一半。
        
        self.layer.mask = maskLayer;
        _maskLayer = maskLayer;
    }
    
    return self;
}

- (void)startAnimaiton {
    //开始执行扇形动画
    CABasicAnimation *strokeEndAni = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAni.fromValue = @0;
    strokeEndAni.toValue = @1;
    strokeEndAni.duration = 1;
    //重复次数
    strokeEndAni.repeatCount = _repeatCount;
    
    [_maskLayer addAnimation:strokeEndAni forKey:@"ani"];
}

- (void)puaseAnimation {
    
    // 将当前时间CACurrentMediaTime转换为layer上的时间, 即将parent time转换为local time
    CFTimeInterval pauseTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    // 设置layer的timeOffset, 在继续操作也会使用到
    self.layer.timeOffset = pauseTime;
    
    // local time与parent time的比例为0, 意味着local time暂停了
    self.layer.speed = 0;
}

- (void)continueAnimation {
    
    // 时间转换
    CFTimeInterval pauseTime = self.layer.timeOffset;
    // 计算暂停时间
    CFTimeInterval timeSincePause = CACurrentMediaTime() - pauseTime;
    // 取消
    self.layer.timeOffset = 0;
    // local time相对于parent time世界的beginTime
    self.layer.beginTime = timeSincePause;
    // 继续
    self.layer.speed = 1;
}

@end
