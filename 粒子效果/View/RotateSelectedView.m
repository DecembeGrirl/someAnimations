//
//  RotateSelectedView.m
//  ScratchableLatex
//
//  Created by 杨淑园 on 16/8/5.
//  Copyright © 2016年 yangshuyaun. All rights reserved.
//

#import "RotateSelectedView.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@implementation RotateSelectedView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:pan];
        btnArray = [[NSMutableArray alloc]init];
        angleArray = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)ConfigUI
{
    self.R = self.centerRadius + self.littleBtnRadius + self.distance;
    NSArray * titleArray = @[@"1",@"2",@"3",@"4",@"5"];
    
    self.angle = 2*M_PI / titleArray.count;
    
    centerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [centerBtn setFrame:CGRectMake(0, 0, self.centerRadius *2, self.centerRadius *2)];
    centerBtn.layer.masksToBounds = YES;
    centerBtn.layer.cornerRadius = self.centerRadius;
    [centerBtn setCenter:CGPointMake(self.center.x, self.center.y- self.frame.origin.y)];
    [centerBtn setBackgroundColor:[UIColor yellowColor]];
    [centerBtn setTitle:@"中心" forState:UIControlStateNormal];
    [centerBtn addTarget:self action:@selector(handleSelectedCenterBtn) forControlEvents:UIControlEventTouchUpInside];
   
    for (int i = 0; i < titleArray.count; i++){
        NSString *str = titleArray[i];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        CGFloat width ;
        if(i == 0)
            width = self.littleBtnRadius * 2+ 12;
        else
            width= self.littleBtnRadius * 2;
        
        [btn setFrame:CGRectMake(0 , 0, width , width)];
        btn.layer.cornerRadius = width / 2;
        btn.center = centerBtn.center;
        [btn setTitle:str forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(handleSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1999+i;
        [btn setBackgroundColor:[UIColor yellowColor]];
        [self addSubview:btn];
        [btnArray addObject:btn];
        CGFloat angle = self.angle* i + M_PI;   // 初始化 btn 所在的圆心角
        angle = angle > 2*M_PI?angle -2*M_PI:angle;
        [angleArray addObject:[NSNumber numberWithFloat:angle]];
    }
     [self addSubview:centerBtn];
    
    circlePathView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height)];
    circlePathView.layer.masksToBounds = YES;
    [self addSubview:circlePathView];
    [self sendSubviewToBack:circlePathView];
    CGFloat  angle = [angleArray[0] floatValue];
    selecetdCenterPoint = CGPointMake(self.R * cos(angle) + centerBtn.center.x,
                                  self.R * sin(angle) + centerBtn.center.y);
    selecetdCenterFrame = CGRectMake(selecetdCenterPoint.x - (self.littleBtnRadius + 15) , selecetdCenterPoint.y -(self.littleBtnRadius + 10), self.littleBtnRadius + 15, self.littleBtnRadius + 10);
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:selecetdCenterPoint radius:self.littleBtnRadius + 10   startAngle:0 endAngle:2*M_PI clockwise:NO];
    myLayer = [CAShapeLayer layer];
    myLayer.path = path1.CGPath;
    myLayer.fillColor =  [UIColor blueColor].CGColor;
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
                CGPoint point = CGPointMake(x, y);
                [btn setCenter:point];
                
            }
            [circlePathView.layer addSublayer:myLayer];
        } completion:nil];
    else
        [UIView animateWithDuration:0.5 animations:^{
            for (int i = 0; i < btnArray.count; i++) {
                UIButton * btn = btnArray[i];
                [btn setCenter:centerBtn.center];
            }
            [myLayer removeFromSuperlayer];
        }];
     _btnIsShow = !_btnIsShow;
}

-(void)handleSelectedBtn:(UIButton *)btn
{
    NSInteger selectedIndex = btn.tag - 1999;
    NSLog(@" %ld",(long)selectedIndex);
}


-(void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    CGPoint touchPoint = [gesture locationInView:self];
    CGPoint point = [gesture translationInView:self];
    CGFloat centerY = self.center.y - self.frame.origin.y;
    CGFloat moveAngle = 2*M_PI/100;
    if(gesture.state == UIGestureRecognizerStateChanged && _btnIsShow == YES)
    {
        if(touchPoint.y > centerY)
            moveAngle =lastPointX<point.x?-moveAngle:moveAngle;
        else
            moveAngle =lastPointX<point.x?moveAngle:-moveAngle;
        selecetdIndex = [self nextToBigBtnIndexWithTouchPoint:touchPoint locationPoint:point];
        for (int i = 0; i <btnArray.count;i++) {
            UIButton *btn = btnArray[i];
            CGFloat angle = [angleArray[i] floatValue]+ moveAngle;
            CGFloat x = self.R * cos(angle) + centerBtn.center.x;
            CGFloat y = self.R * sin(angle) + centerBtn.center.y;
            [UIView animateWithDuration:0.1 animations:^{
                CGFloat width;
                if(CGRectIntersectsRect(btn.frame, selecetdCenterFrame))
                {
                    width = self.littleBtnRadius*2 + 15;
                    selecetdIndex = i;
                }
                else
                {
                    width = self.littleBtnRadius*2;
                }
                [btn setFrame:CGRectMake(0, 0, width, width)];
                btn.layer.cornerRadius = width/2;
                [btn setCenter:CGPointMake(x, y)];
            }];
            angle += moveAngle;
            [angleArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:angle]];
        }
        lastPointX = point.x;
    }
    else if ( gesture.state == UIGestureRecognizerStateEnded)
    {
        // 旋转的角度
        CGFloat moveAngle = M_PI - [angleArray[selecetdIndex] floatValue];
        moveAngle =(lastPointX<point.x ||lastPointX<point.x)?-moveAngle:moveAngle;
        
        [UIView animateWithDuration:0.3 animations:^{
            for (int i = 0; i < btnArray.count; i ++) {
                UIButton * btn = btnArray[i];
                CGFloat angle = [angleArray[i] floatValue];
                
                CGFloat x = self.R * cos(angle + moveAngle)+ centerBtn.center.x ;
                CGFloat y = self.R * sin(angle + moveAngle) + centerBtn.center.y ;
                if(i != selecetdIndex)
                {
                    [btn setFrame:CGRectMake(0, 0, self.littleBtnRadius * 2, self.littleBtnRadius *2)];
                    btn.layer.cornerRadius =self.littleBtnRadius;
                }
                else
                {
                    [btn setFrame:CGRectMake(0, 0, self.littleBtnRadius * 2, self.littleBtnRadius *2)];
                    btn.layer.cornerRadius =self.littleBtnRadius;
                }
                [btn setCenter:CGPointMake(x, y)];
                [angleArray  replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:(angle + moveAngle)]];
            }
        }];
    }
}

-(NSInteger)nextToBigBtnIndexWithTouchPoint:(CGPoint)touchPoint locationPoint:(CGPoint)locationPoint
{
    CGFloat centerY = self.center.y - self.frame.origin.y;
    if(touchPoint.y > centerY)
    {
        selecetdIndex =lastPointX<locationPoint.x?selecetdIndex + 1:selecetdIndex-1;
    }
    else
        selecetdIndex =lastPointX<locationPoint.x?selecetdIndex-1:selecetdIndex+1;
    
    selecetdIndex = selecetdIndex < 0?btnArray.count-1:selecetdIndex>=btnArray.count?0:selecetdIndex;
    
    return  selecetdIndex;
}

-(void)resetBtnFrameWithLocationPoint:(CGPoint)locationPoint translationPoint:(CGPoint)tranlationPoint
{
    CGFloat x = tranlationPoint.x;
    CGFloat y ;
    CGFloat centerX = self.center.x;
    CGFloat centerY = self.center.y -100;
    CGFloat moveX;
    if(locationPoint.y > centerY)
        moveX =lastPointX<tranlationPoint.x?-5:5;
    else
        moveX =lastPointX<tranlationPoint.x?5:-5;
    
    for (UIButton * btn in btnArray)
    {
        x= btn.center.x + moveX;
        if(lastCenter.x >= btn.center.x)
        {
            if(btn.center.y < centerY)
            {
                x = btn.center.x + moveX;
                y = -sqrt(pow(self.R,2)-pow(x-centerX,2))+centerY;
            }
            else
            {
                x = btn.center.x - moveX;
                if (x <= centerX - self.R )
                {
                    x = centerX - self.R + moveX;
                    y = -sqrt(pow(self.R,2)-pow(x-centerX,2))+centerY;
                }
                else if (x >= centerX+ self.R)
                {
                    x = centerX + self.R + moveX;
                    y = -sqrt(pow(self.R,2)-pow(x-centerX,2))+centerY;
                }
                else
                    y = sqrt(pow(self.R,2)-pow(x-centerX,2))+centerY;
            }
        }
        else
        {
            if(btn.center.y < centerY)
            {
                x = btn.center.x - moveX;
                y = sqrt(pow(self.R,2)-pow(x-centerX,2))+centerY;
            }
            else
            {
                x = btn.center.x + moveX;
                if (x <= centerX - self.R)
                {
                    x = centerX - self.R - moveX;
                    y = sqrt(pow(self.R,2)-pow(x-centerX,2))+centerY;
                }
                else if (x >= centerX+ self.R)
                {
                    x = centerX + self.R - moveX;
                    y = sqrt(pow(self.R,2)-pow(x-centerX,2))+centerY;
                }
                else
                    y = -sqrt(pow(self.R,2)-pow(x-centerX,2))+centerY;
            }
        }
        // 圆的方程式
        [UIView animateWithDuration:0.1 animations:^{
            [btn setCenter:CGPointMake(x, y)];
        }];
    }
}





@end
