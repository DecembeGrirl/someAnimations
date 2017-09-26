//
//  EmitterController.m
//  粒子效果
//
//  Created by 杨淑园 on 16/5/31.
//  Copyright © 2016年 yangshuyaun. All rights reserved.
//

#import "EmitterController.h"

@interface EmitterController ()
@property (nonatomic, strong)CAEmitterLayer *emitterLayer;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UILabel *lab;
@end

@implementation EmitterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
     self.navigationController.navigationBarHidden = NO;
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn setFrame:CGRectMake(0, 0, 100, 100)];
    [self.btn setCenter:self.view.center];
    [self.btn setTitle:@"变身吧!" forState:UIControlStateNormal];
    [self.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.btn];
    [self.btn addTarget:self action:@selector(ClickBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.lab = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    self.lab.center = self.view.center;
    self.lab.text = @"+5金币";
    self.lab.textAlignment = NSTextAlignmentCenter;
    self.lab.textColor = [UIColor colorWithRed:254/255.0 green:211/255.0 blue:10/255.0 alpha:1];
    [self.lab setBackgroundColor:[UIColor purpleColor]];
    [self.view addSubview: self.lab ];
    self.lab.hidden = YES;
    
//    for (int i = 0; i< 10; i++) {
        [self initEmitter];
//    }
}

//初始化粒子
-(void)initEmitter
{
    //发射源
    CAEmitterLayer * emitter = [CAEmitterLayer layer];
    
//    emitter.frame = CGRectMake(0, 0, CGRectGetWidth(self.lab.frame), CGRectGetHeight(self.lab.frame));
    self.emitterLayer = emitter;
    [self.view.layer addSublayer:self.emitterLayer];
    
    //发射源的形状
    emitter.emitterShape = kCAEmitterLayerCircle;
    //发射模式
//    emitter.emitterMode =kCAEmitterLayerOutline;
    
    emitter.emitterPosition = CGPointMake( self.view.frame.size.width - 50 , self.view.frame.size.height - 50);
    emitter.emitterSize = CGSizeMake(20, 20);
    
    CAEmitterCell * cell = [CAEmitterCell emitterCell];
    cell.name = @"mamimamihonga";
    //粒子展现的图片
    cell.contents = (__bridge id)[UIImage imageNamed:@"coin"].CGImage;
    //粒子透明度在生命周期中改变的速度
    cell.alphaSpeed = -0.2;
    //粒子生命周期
    cell.lifetime =arc4random_uniform(6)+1;
    cell.lifetimeRange =1.5;
    //粒子生产系数
    cell.birthRate = 10.0f;
    //粒子速度
    cell.velocity = arc4random_uniform(300)+100;
    //粒子速度范围
    cell.velocityRange = 80;
    //周围发射角度
    cell.emissionRange = M_PI_2 / 6;
    //发射Z轴方向的角度
//    cell.emissionLatitude = -M_PI ;
    //x-y平面的发射方向
    cell.emissionLongitude = M_PI +M_PI / 2;
    //粒子y方向的加速度
//    cell.yAcceleration = 80;
    emitter.emitterCells = @[cell];
    
}
-(void)ClickBtn
{
    [self beginAnimation];
}

/**
 *  开始动画
 **/

-(void)beginAnimation
{
    __weak typeof(self) weakSelf = self;
    
    self.lab.hidden = NO;
    self.btn .hidden = YES;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:5 options:UIViewAnimationOptionCurveLinear animations:^{
        
        // 粒子效果动画
        CABasicAnimation * emitterBirth = [CABasicAnimation animationWithKeyPath:@"emitterCells.mamimamihonga.birthRate"];
        emitterBirth.fromValue =@50;
        emitterBirth.toValue = @0;
        emitterBirth.duration = 0.5f;
        emitterBirth.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [weakSelf.emitterLayer addAnimation:emitterBirth forKey:@"cellBirth"];
        //label  放大动画
        CABasicAnimation * aniScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"]; //transform.scale 是系统的规定的 用于放大效果的Key
        aniScale.fromValue = @0.2;
        aniScale.toValue = @2;
        aniScale.duration = 1.0f;
        aniScale.delegate = self;
        aniScale.removedOnCompletion = NO;
        aniScale.repeatCount = 1;
        [weakSelf.lab.layer addAnimation:aniScale forKey:@"coin_scale"];
    } completion:^(BOOL finished) {
    }];
}
#pragma mark - 动画结束
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    if(anim == [self.lab.layer animationForKey:@"coin_scale"])
    {
        CGPoint toPoint = CGPointMake(CGRectGetMaxX(self.view.frame), CGRectGetMaxY(self.view.frame));
        //移动 动画
        CABasicAnimation *aniMove = [CABasicAnimation animationWithKeyPath:@"position"];  //position 改变位置
        aniMove.fromValue = [NSValue valueWithCGPoint:self.lab.layer.position];
        aniMove.toValue = [NSValue valueWithCGPoint:toPoint];
        
        //缩小动画
        CABasicAnimation * aniScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        aniScale.fromValue = @1.0;
        aniScale.toValue = @0.2;
        
        //旋转动画
        CABasicAnimation * aniRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];  //transform.rotation.z  绕z轴方向旋转
        aniRotation.toValue = [NSNumber numberWithFloat:M_PI *2];
        aniRotation.cumulative = YES;
        
        CAAnimationGroup * aniGroup = [CAAnimationGroup animation];
        aniGroup.duration = 0.5f;
        aniGroup.delegate = self;
        aniGroup.animations = @[aniMove,aniScale,aniRotation];
        aniGroup.removedOnCompletion = NO;
//        aniGroup.fillMode = kCAFillModeForwards;
        [self.lab.layer removeAllAnimations];
        [self.lab.layer addAnimation:aniGroup forKey:@"aniMove_aniScale_aniRotation_aniGroup"];
        
    }
    else if(anim == [self.lab.layer animationForKey:@"aniMove_aniScale_aniRotation_aniGroup"])
    {
        self.lab.hidden = YES;
        self.btn .hidden = NO;
    }
}



@end
