//
//  AniView.h
//  粒子效果
//
//  Created by 杨淑园 on 16/6/23.
//  Copyright © 2016年 yangshuyaun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AniView : UIView
@property (nonatomic, strong)CAShapeLayer * circleLayer;   //圆形
@property (nonatomic, strong)CAShapeLayer * triangleLayer; //三角形
@property (nonatomic, strong)CAShapeLayer * lineLayer1;     // 线条
@property (nonatomic, strong)CAShapeLayer * lineLayer2;     //
@property (nonatomic, strong)CAShapeLayer * waveFillLayer; //波浪注水效果

@property (nonatomic, strong) UIView *waveView;
@property (nonatomic, strong) UILabel * wellComeLabel;

@property (nonatomic, strong)CADisplayLink *link;
@property (nonatomic, assign) CGFloat cycle;   // 振幅周期
@property (nonatomic, assign)CGFloat offsetX1 ; // x轴的偏移量
@property (nonatomic, assign) CGFloat waveWidth; // 整个波的宽度
@property (nonatomic, assign) CGFloat waveHeight;  // 振幅大小

@property (nonatomic, assign) CGFloat processWeigth;   // 进度比重

@property (nonatomic, assign) CGFloat proccessBase;    // 容器的每1单位长度的大小为多少个百分比  单位百分比基数

@property (nonatomic, assign) CGFloat speed ;   // 波速

@property (nonatomic, assign) CGFloat  height;   //  占容器的位置

@property (nonatomic, strong)UIBezierPath * trianglePath;
@property (nonatomic, strong)UIBezierPath * triangleLeftfPath;
@property (nonatomic, strong)UIBezierPath * triangleRightPath;
@property (nonatomic, strong)UIBezierPath * triangleUpPath;


@property (nonatomic, assign) CGPoint leftPoint;
@property (nonatomic, assign) CGPoint rightPoint;
@property (nonatomic, assign) CGPoint upPoint;


-(void)CreatCircleLayer;
-(void)removeLayer;
@end
