//
//  CircleController.m
//  粒子效果
//
//  Created by 杨淑园 on 16/5/31.
//  Copyright © 2016年 yangshuyaun. All rights reserved.
//

#import "CircleController.h"

@interface CircleController ()
@property (nonatomic, strong) UIImageView * myImageView;
@property (nonatomic, strong) CAShapeLayer *shapLayer;
@property (nonatomic, assign) BOOL toBig;
@end

@implementation CircleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBarHidden = NO;
    self.myImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.myImageView.center = self.view.center;
    [self.myImageView setImage:[UIImage imageNamed:@"1.jpg"]];
    [self.view addSubview:self.myImageView];
    self.myImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HandleTap)];
    [self.myImageView addGestureRecognizer:tap];
    
    self.shapLayer = [CAShapeLayer layer];
    self.shapLayer.frame =CGRectMake(0, 0 , CGRectGetWidth(self.myImageView.frame), CGRectGetHeight(self.myImageView.frame));
    self.shapLayer.fillRule = kCAFillRuleEvenOdd;
    self.shapLayer.masksToBounds = YES;
    self.shapLayer.fillColor = [UIColor redColor].CGColor;
    self.shapLayer.lineCap = kCALineCapRound;
    [self.myImageView.layer addSublayer:self.shapLayer];
    
    UIBezierPath * aPath = [UIBezierPath bezierPathWithRect:self.myImageView.frame];
    [aPath appendPath:[UIBezierPath bezierPathWithArcCenter:self.shapLayer.position radius:100 startAngle:0 endAngle:M_PI * 2  clockwise:YES]];
    self.shapLayer.path = aPath.CGPath;
}
-(void)HandleTap
{
    self.navigationController.navigationBarHidden = YES;
    if(!self.toBig)
    {
        [UIView animateWithDuration:3.0f delay:0.0f usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
            self.toBig = YES;
            
            CABasicAnimation * aniCorneRadius = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            CGFloat height_2 = CGRectGetHeight(self.myImageView.frame) / 2;
            CGFloat width_2 = CGRectGetWidth(self.myImageView.frame)/2;
            
            double toValue = hypot(height_2, width_2) /100; // 函数 hypot 已知直角三角形的两直角边 求斜边
            aniCorneRadius.fromValue = @1;
            aniCorneRadius.toValue = @(toValue);
            aniCorneRadius.repeatCount = 1;
            aniCorneRadius.duration = 1.5f;
            aniCorneRadius.cumulative = YES;
//            aniCorneRadius.delegate = self;
            
            aniCorneRadius.fillMode=kCAFillModeForwards;
            aniCorneRadius.removedOnCompletion = NO;
            aniCorneRadius.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            [self.shapLayer addAnimation:aniCorneRadius forKey:@"layer_scalse_big"];
        } completion:^(BOOL finished) {
        }];
    }
    else
    {
        [UIView animateWithDuration:3.0f delay:0.0f usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
            
            self.toBig = NO;
            CABasicAnimation * aniCorneRadius = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            CGFloat height_2 = CGRectGetHeight(self.myImageView.frame) / 2;
            CGFloat width_2 = CGRectGetWidth(self.myImageView.frame)/2;
            
            
            double toValue = hypot(height_2, width_2) /100;
            aniCorneRadius.fromValue = @(toValue);
            aniCorneRadius.toValue = @1;
            aniCorneRadius.repeatCount = 1;
            aniCorneRadius.duration = 1.5f;
            aniCorneRadius.fillMode=kCAFillModeForwards;
            aniCorneRadius.removedOnCompletion = NO;
            aniCorneRadius.cumulative = YES;
//            aniCorneRadius.delegate = self;
            aniCorneRadius.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [self.shapLayer addAnimation:aniCorneRadius forKey:@"layer_scalse_small"];
        } completion:^(BOOL finished) {
            
        }];
        
    }
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(anim == [self.shapLayer animationForKey:@"layer_scalse_small"])
    {
        self.navigationController.navigationBarHidden = NO;
    }

}


@end
