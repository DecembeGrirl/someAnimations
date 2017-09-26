//
//  YSHYLab.m
//  粒子效果
//
//  Created by 杨淑园 on 16/6/2.
//  Copyright © 2016年 yangshuyaun. All rights reserved.
//

#import "YSHYLab.h"

@implementation YSHYLab

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self inits];
    }
    return self;
}

-(instancetype)init
{
    if(self = [super init])
    {
        [self inits];
    }
    return self;
}

-(void)inits
{
    [self setBackgroundColor:[UIColor colorWithRed:215 green:215 blue:215 alpha:0.6]];
    
    self.userInteractionEnabled = YES;
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleCkiclBtn)];
//    tap.delegate = self;
////    [self addGestureRecognizer:tap];
}


-(void)handleCkiclBtn
{
    NSString * str= [NSString stringWithFormat:@"点击了 %@",self.text];
    NSLog(@"%@",str);
    self.selectedBlock(self.isPause);
     self.isPause = !self.isPause;
}

-(void)beginAni
{
    [UIView animateWithDuration:5.0f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
        CABasicAnimation * aniScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        aniScale.delegate = self;
        
        aniScale.fromValue =@0.0f;
        aniScale.toValue = @1.5f;
        aniScale.removedOnCompletion = NO;
        aniScale.repeatCount = 1;
        aniScale.fillMode = kCAFillModeForwards; // 保持动画后的状态
        aniScale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        aniScale.duration = 5;
        [self.layer addAnimation:aniScale forKey:@"label_scale_big"];
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)pausedAni
{
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;
    self.layer.timeOffset = pausedTime;
}

-(void)resumeAni
{
    CFTimeInterval pausedTime = [self.layer timeOffset];
    self.layer.speed = 1.0f;
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    
    CFTimeInterval timeSicePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSicePause;
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(anim == [self.layer animationForKey:@"label_scale_big"])
    {
        [UIView animateKeyframesWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
            
            self.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }

}



@end
