//
//  AniView.m
//  粒子效果
//
//  Created by 杨淑园 on 16/6/23.
//  Copyright © 2016年 yangshuyaun. All rights reserved.
//

#import "AniView.h"

#define CIRCLERADUIS  ([UIScreen mainScreen].bounds.size.width /2 - 100)

@implementation AniView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self CreatCircleLayer];
    }
    return self;
}

-(void)CreatCircleLayer
{
    self.circleLayer = [CAShapeLayer layer];
    self.circleLayer.bounds = self.frame;   // 确定 layer的大小
    self.circleLayer.position = self.center; // 确定layer的 起始位置
    self.circleLayer.fillColor = [UIColor redColor].CGColor;
    self.circleLayer.fillRule = kCAFillRuleEvenOdd;
    self.circleLayer.fillMode = kCAFillModeForwards;
    self.circleLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:self.circleLayer];
    
    
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:self.center radius:CIRCLERADUIS startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    self.circleLayer.path = path.CGPath;
    
    [self animationCircleScale];
}
// 圆由小变大 动画
-(void)animationCircleScale
{
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        
        CABasicAnimation * aniScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        aniScale.fromValue = @0.0;
        aniScale.toValue = @1;
        aniScale.duration = 1.0f;
        aniScale.delegate = self;
        // 下面两句要一起使用才能是动画结束后保持最后的样子
        aniScale.fillMode=kCAFillModeForwards;  // 动画保持最后的样子
        aniScale.removedOnCompletion = NO;    //设置动画执行完毕后不删除动画
        aniScale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [self.circleLayer addAnimation:aniScale forKey:@"circleScale"];
        
    } completion:^(BOOL finished) {
        
    }];
}
// 实现圆的捏的弹性效果
-(void)AnimaPinch
{
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        CABasicAnimation * ani1 = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
        ani1.fromValue = @1;
        ani1.toValue = @0.9;
        ani1.duration = 0.25;
        ani1.fillMode = kCAFillModeForwards;
        ani1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CABasicAnimation * ani2 = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
        ani2.fromValue = @1;
        ani2.toValue = @0.9;
        ani2.beginTime = ani1.beginTime + ani1.duration;
        ani2.duration = 0.25;
        ani2.fillMode = kCAFillModeForwards;
        ani2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CABasicAnimation * ani3 = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
        ani3.fromValue = @0.9;
        ani3.toValue = @1;
        ani3.beginTime = ani2.beginTime + ani2.duration;
        ani3.duration = 0.25;
        ani3.fillMode = kCAFillModeForwards;
        ani3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CABasicAnimation * ani4 = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
        ani4.fromValue = @0.9;
        ani4.toValue = @1;
        ani4.duration = 0.25;
        ani4.beginTime = ani3.beginTime + ani3.duration;
        ani4.fillMode = kCAFillModeForwards;
        ani4.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CAAnimationGroup * aniGroup = [CAAnimationGroup animation];
        aniGroup.duration =ani1.duration + ani2.duration + ani3.duration + ani4.duration;
        aniGroup.delegate = self;
        aniGroup.animations = @[ani1,ani2,ani3,ani4];
        aniGroup.removedOnCompletion = NO;
        
        [self.circleLayer addAnimation:aniGroup forKey:@"circlePinch"];
    } completion:^(BOOL finished) {
        
    }];
}

// 创建三角形 以及 各个动画的状态
-(void)CreatTriangle
{
    self.triangleLayer = [CAShapeLayer layer];
    self.triangleLayer.bounds = self.frame;   // 确定 layer的大小
    self.triangleLayer.position = self.center; // 确定layer的 起始位置
    [self.layer addSublayer:self.triangleLayer];
    
    // 下面三个属性设置 圆角
    self.triangleLayer.lineCap = kCALineCapRound;
    self.triangleLayer.lineJoin = kCALineJoinRound;
    self.triangleLayer.lineWidth = 6.0;
    
    self.triangleLayer.fillColor = [UIColor redColor].CGColor;
    self.triangleLayer.strokeColor = [UIColor redColor].CGColor;
    
    self.trianglePath = [UIBezierPath bezierPath];
    double cosValue  = cos(M_PI /6);
    double sinValue  = sin(M_PI /6);
    
    // up
    CGPoint point1 = CGPointMake(self.center.x, self.center.y - CIRCLERADUIS + 5);
    //left
    CGPoint point2 = CGPointMake(self.center.x - cosValue*CIRCLERADUIS + 5, self.center.y + sinValue*CIRCLERADUIS);
    //right
    CGPoint point3 = CGPointMake(self.center.x + cosValue*CIRCLERADUIS - 5, self.center.y + sinValue*CIRCLERADUIS);
    // 画三角形
    [self.trianglePath moveToPoint:point1];
    [self.trianglePath addLineToPoint:point2];
    [self.trianglePath addLineToPoint:point3];
    [self.trianglePath closePath];
    self.triangleLayer.path = self.trianglePath.CGPath;
    
    // 左边动画 效果
    self.triangleLeftfPath = [UIBezierPath bezierPath];
    self.leftPoint = CGPointMake(point2.x - 20, point2.y + 5);
    [self.triangleLeftfPath moveToPoint:point1];
    [self.triangleLeftfPath addLineToPoint:self.leftPoint];
    [self.triangleLeftfPath addLineToPoint:point3];
    [self.triangleLeftfPath closePath];
    
    //右边动画的效果
    self.triangleRightPath = [UIBezierPath bezierPath];
    self.rightPoint = CGPointMake(point3.x + 20, point2.y + 5);
    [self.triangleRightPath moveToPoint:point1];
    [self.triangleRightPath addLineToPoint:self.leftPoint];
    [self.triangleRightPath addLineToPoint:self.rightPoint];
    [self.triangleRightPath closePath];
    
    //上边动画的效果
    self.triangleUpPath= [UIBezierPath bezierPath];
    self.upPoint = CGPointMake(point1.x , point1.y - 20);
    [self.triangleUpPath moveToPoint:self.upPoint];
    [self.triangleUpPath addLineToPoint:self.leftPoint];
    [self.triangleUpPath addLineToPoint:self.rightPoint];
    [self.triangleUpPath closePath];
    
    [self aniTraignle];
    
}

// 三角形的动画出现
-(void)aniTriangleShow
{
    CABasicAnimation * aniLeft = [CABasicAnimation animationWithKeyPath:@"path"];
    aniLeft.fromValue = (__bridge id _Nullable)(self.trianglePath.CGPath);
    aniLeft.toValue = (__bridge id _Nullable)(self.triangleLeftfPath.CGPath);
    aniLeft.duration = 0.25;
    aniLeft.fillMode = kCAFillModeForwards;  // 动画结束后一直保持动画的最后状态
    aniLeft.repeatCount = 1;
    
    CABasicAnimation * aniRight = [CABasicAnimation animationWithKeyPath:@"path"];
    aniRight.fromValue = (__bridge id _Nullable)(self.triangleLeftfPath.CGPath);
    aniRight.toValue = (__bridge id _Nullable)(self.triangleRightPath.CGPath);
    aniRight.beginTime = aniLeft.beginTime + aniLeft.duration;
    aniRight.duration = 0.2;
    aniRight.fillMode = kCAFillModeForwards;
    aniRight.repeatCount = 1;
    
    CABasicAnimation * aniUp = [CABasicAnimation animationWithKeyPath:@"path"];
    aniUp.fromValue = (__bridge id _Nullable)(self.triangleRightPath.CGPath);
    aniUp.toValue = (__bridge id _Nullable)(self.triangleUpPath.CGPath);
    aniUp.beginTime = aniRight.beginTime + aniRight.duration;
    aniUp.duration = 0.15;
    aniUp.fillMode = kCAFillModeForwards;
    aniUp.repeatCount = 1;
    
    CAAnimationGroup * group = [CAAnimationGroup animation];
    group.animations = @[aniLeft,aniRight,aniUp];
    group.duration = aniLeft.duration + aniRight.duration + aniUp.duration;
    group.delegate = self;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    [self.triangleLayer addAnimation:group forKey:@"triangle"];
}

// 旋转三角形 并且 圆形缩小
-(void)aniRoationTraignle
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        // 三角形旋转
        CABasicAnimation * aniScaleTraingle = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        aniScaleTraingle.toValue =@(M_PI * 2);
        aniScaleTraingle.removedOnCompletion = NO;
        aniScaleTraingle.duration = 0.5f;
        aniScaleTraingle.fillMode = kCAFillModeForwards;
        aniScaleTraingle.delegate = self;
        aniScaleTraingle.timingFunction =[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [self.triangleLayer addAnimation:aniScaleTraingle forKey:@"triangleRotation"];
        
        // 圆形缩小
        CABasicAnimation *aniCirCleScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        aniCirCleScale.fromValue = @1;
        aniCirCleScale.toValue = @0;
        aniCirCleScale.removedOnCompletion = NO;
        aniCirCleScale.duration = 0.5f;
        aniCirCleScale.delegate = self;
        aniCirCleScale.fillMode = kCAFillModeForwards;
        aniCirCleScale.timingFunction =[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [self.circleLayer addAnimation:aniCirCleScale forKey:@"circleScale_small"];
    } completion:^(BOOL finished) {
    }];
}

-(CAShapeLayer *)CreatLineLayer
{
    CAShapeLayer * lineLayer = [CAShapeLayer layer];
    lineLayer.bounds = self.frame;   // 确定 layer的大小
    lineLayer.position = self.center; // 确定layer的 起始位置
    lineLayer.lineWidth = 3.0f;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    lineLayer.strokeColor = [UIColor blueColor].CGColor;
    CGFloat width= self.rightPoint.x - self.leftPoint.x + 4;
    UIBezierPath *linePath =[UIBezierPath bezierPath];
    CGPoint point1 = CGPointMake(self.leftPoint.x - 2 , self.leftPoint.y + 5 );
    CGPoint point2 = CGPointMake(point1.x, point1.y - width);
    CGPoint point3 = CGPointMake(point2.x + width , point2.y);
    CGPoint point4 = CGPointMake(point3.x, point1.y);
    
    [linePath moveToPoint:point1];
    [linePath addLineToPoint:point2];
    [linePath addLineToPoint:point3];
    [linePath addLineToPoint:point4];
    
    [linePath closePath];
    
    lineLayer.path = linePath.CGPath;
    return lineLayer;
}

// 画线
-(void)AniLine1Show
{
    self.lineLayer1 = [self CreatLineLayer];
    [self.layer addSublayer:self.lineLayer1];
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CABasicAnimation * aniLine = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        aniLine.fromValue = @0;
        aniLine.toValue = @1;
        aniLine.duration = 0.5f;
        aniLine.removedOnCompletion = NO;
        aniLine.delegate = self;
        aniLine.fillMode = kCAFillModeForwards;
        aniLine.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.lineLayer1 addAnimation:aniLine forKey:@"line_show"];
        
    } completion:^(BOOL finished) {
    }];
}

-(void)AniLine2Show
{
    self.lineLayer2 = [self CreatLineLayer];
    self.lineLayer2.strokeColor = [UIColor greenColor].CGColor;
    [self.layer addSublayer:self.lineLayer2];
//    self.lineLayer1.strokeColor = [UIColor greenColor].CGColor;
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CABasicAnimation * aniLine2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        aniLine2.fromValue = @0;
        aniLine2.toValue = @1;
        aniLine2.duration = 0.5f;
        aniLine2.removedOnCompletion = NO;
        aniLine2.delegate = self;
        aniLine2.fillMode = kCAFillModeForwards;
        aniLine2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.lineLayer2 addAnimation:aniLine2 forKey:@"line2_show"];
//        [self.lineLayer1 addAnimation:aniLine2 forKey:@"line2_show"];
    } completion:^(BOOL finished) {
    }];
}

// 注水效果
-(void)aniWaveFill
{
    self.processWeigth = 0;
    self.height = 0;
    
    self.offsetX1 = 0;
    self.speed = 8;
    
    self.waveWidth =self.rightPoint.x - self.leftPoint.x + 4;
    self.waveHeight = 5;
    
    self.proccessBase = 100 / self.waveWidth ;
    self.cycle = M_PI / self.waveWidth /2;
    
    // 盛放波浪的view
    self.waveView = [[UIView alloc]initWithFrame:CGRectMake(self.leftPoint.x - 2 , self.leftPoint.y - self.waveWidth + 4 , self.waveWidth , self.waveWidth)];
    [self.waveView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.waveView];
    
    self.wellComeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.wellComeLabel.text = @"WellCome";
    self.wellComeLabel.textColor = [UIColor whiteColor];
    self.wellComeLabel.textAlignment = NSTextAlignmentCenter;
    [self.wellComeLabel setCenter:self.center];
    
    self.waveFillLayer = [CAShapeLayer layer];
    self.waveFillLayer.frame = CGRectMake(0 , self.waveWidth , self.waveWidth , self.waveWidth);
    self.waveFillLayer.fillColor = [UIColor greenColor].CGColor;
    [self.waveView.layer addSublayer:self.waveFillLayer];
    
    [self startDisPlay];

}
// 绘制波浪
-(void)HandleAnimation
{
    self.processWeigth -= 1;
    if(fabs(self.processWeigth) > self.waveView.frame.size.height)
    {
        [self stopDisPlay];
    }
    self.offsetX1 += self.speed;
    //设置起始位置
    CGFloat startY=self.waveHeight * sinf(self.offsetX1* self.cycle);
    CGMutablePathRef  pathRef = CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, NULL, 0, startY);
    for (CGFloat i = 0.0; i < self.waveWidth; i ++) {
        CGFloat y = self.waveHeight* sinf(5.5 * i/ self.waveWidth + self.offsetX1 *self.cycle) + self.processWeigth;
        CGPathAddLineToPoint(pathRef, NULL, i, y);
    }
    CGPathAddLineToPoint(pathRef, NULL, self.waveWidth, self.height);
    CGPathAddLineToPoint(pathRef, NULL, 0, self.height);
    CGPathCloseSubpath(pathRef);
    //设置第一个波layer的path
    self.waveFillLayer.path = pathRef;
    self.waveFillLayer.fillColor = [UIColor greenColor].CGColor;
    CGPathRelease(pathRef);
}

-(void)startDisPlay
{
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(HandleAnimation)];
    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
-(void)stopDisPlay
{
    [self.link invalidate];
    self.link = nil;
    
    [self viewScale];
}
//盛放 wellcome 的view 放大
-(void)viewScale
{
    [self.waveView setBackgroundColor:[UIColor greenColor]];
    [self.waveFillLayer removeFromSuperlayer];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.waveView setFrame:self.bounds];
        self.waveView.center = self.center;

    } completion:^(BOOL finished) {
        [self addSubview:self.wellComeLabel];
        CABasicAnimation * ani = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        ani.fromValue = @0;
        ani.toValue = @2;
        ani.removedOnCompletion = NO;
        ani.repeatCount = 1;
        ani.duration = 1;
        ani.fillMode = kCAFillModeForwards;
        ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [self.wellComeLabel.layer addAnimation:ani forKey:@"welComeLabel_Scale"];
    }];
}
-(void)aniTraignle
{
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self aniTriangleShow];
    } completion:^(BOOL finished) {
    }];
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(anim == [self.circleLayer animationForKey:@"circleScale"])
    {
        [self AnimaPinch];
    }
    else if(anim == [self.circleLayer animationForKey:@"circlePinch"])
    {
        [self CreatTriangle];
    }else if(anim == [self.triangleLayer animationForKey:@"triangle"])
    {
        [self aniRoationTraignle];
    }
    else if(anim == [self.triangleLayer animationForKey:@"triangleRotation"])
    {
        [self AniLine1Show];
    }
    else if (anim == [self.lineLayer1 animationForKey:@"line_show"])
    {
        [self AniLine2Show];
    }else if (anim == [self.lineLayer2 animationForKey:@"line2_show"])
    {
        [self aniWaveFill];
    }
}

-(void)removeLayer
{
    [self.circleLayer removeFromSuperlayer];
    [self.triangleLayer removeFromSuperlayer];
    [self.lineLayer1 removeFromSuperlayer];
    [self.lineLayer2 removeFromSuperlayer];
    [self.waveView removeFromSuperview];
}


@end
