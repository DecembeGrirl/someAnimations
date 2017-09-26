//
//  YSHYQuarterCircleMenu.m
//  ScratchableLatex
//
//  Created by 杨淑园 on 16/8/10.
//  Copyright © 2016年 yangshuyaun. All rights reserved.
//

#import "YSHYQuarterCircleMenu.h"

@implementation YSHYQuarterCircleMenu

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        btnArray = [[NSMutableArray alloc]init];
        angleArray = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)ConfigUI
{
    self.R = self.centerRadius + self.littleBtnRadius + self.distance;
    NSArray * titleArray = @[@"1",@"2",@"3",@"4"];
    
    self.angle =( M_PI*2 /3 )/(titleArray.count-1);
   
    centerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [centerBtn setFrame:CGRectMake(0, self.frame.size.height - self.centerRadius *2, self.centerRadius *2, self.centerRadius *2)];
    centerBtn.layer.masksToBounds = YES;
    centerBtn.layer.cornerRadius = self.centerRadius;
    [centerBtn setBackgroundColor:[UIColor yellowColor]];
    [centerBtn setTitle:@"中心" forState:UIControlStateNormal];
    [centerBtn addTarget:self action:@selector(handleSelectedCenterBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    for (int i = 0; i < titleArray.count; i++){
        NSString *str = titleArray[i];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.layer.cornerRadius = self.littleBtnRadius;
        [btn setFrame:CGRectMake(0 , 0, self.littleBtnRadius * 2 , self.littleBtnRadius *2)];
        btn.center = centerBtn.center;
        [btn setTitle:str forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(handleSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1999+i;
        [btn setBackgroundColor:[UIColor yellowColor]];
        [self addSubview:btn];
        [btnArray addObject:btn];
        CGFloat angle = -self.angle* i + M_PI/12;   // 初始化 btn 所在的圆心角
        [angleArray addObject:[NSNumber numberWithFloat:angle]];
    }
    [self addSubview:centerBtn];
    
    circlePathView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height)];
    circlePathView.layer.masksToBounds = YES;
    [self addSubview:circlePathView];
    [self sendSubviewToBack:circlePathView];
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:centerBtn.center radius:self.R - self.littleBtnRadius startAngle:M_PI_4 endAngle:-M_PI_4*3 clockwise:NO]; // NO 表示逆时针
//    [path1 appendPath:[UIBezierPath bezierPathWithArcCenter:centerBtn.center radius:self.R + self.littleBtnRadius startAngle:M_PI_4 endAngle:-M_PI_4*3 clockwise:NO]];
    [path1 addArcWithCenter:centerBtn.center radius:self.R + self.littleBtnRadius startAngle:M_PI_4 endAngle:-M_PI_4*3 clockwise:NO];
  
    myLayer = [CAShapeLayer layer];
    myLayer.path = path1.CGPath;
    myLayer.fillRule = kCAFillRuleEvenOdd;
    myLayer.lineCap = kCALineCapRound;
    myLayer.strokeColor = [UIColor clearColor].CGColor;
    myLayer.opacity = 0.5;
   
}

-(void)handleSelectedCenterBtn
{
    if(_btnIsShow == NO)
        
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.4 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            for (int i = 0; i < btnArray.count; i++) {
                UIButton * btn = btnArray[i];
                CGFloat angle = [angleArray[i] floatValue];
                CGFloat x = self.R * cos(angle) + centerBtn.center.x;
                CGFloat y = self.R * sin(angle) + centerBtn.center.y;
                [btn setCenter:CGPointMake(x, y)];
                [circlePathView.layer addSublayer:myLayer];
                
            }
        } completion:nil];

    else
        [UIView animateWithDuration:0.5 animations:^{
            for (int i = 0; i < btnArray.count; i++) {
                UIButton * btn = btnArray[i];
                [btn setCenter:centerBtn.center];
                [myLayer removeFromSuperlayer];
            }
        }];
    _btnIsShow = !_btnIsShow;
}

-(void)handleSelectedBtn:(UIButton *)btn
{
    NSInteger selectedIndex = btn.tag - 1999;
    NSLog(@" %ld",(long)selectedIndex);
}

@end
