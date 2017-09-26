//
//  WaveController.m
//  粒子效果
//
//  Created by 杨淑园 on 16/5/31.
//  Copyright © 2016年 yangshuyaun. All rights reserved.
//

#import "WaveController.h"

@interface WaveController ()
@property (nonatomic , strong) CAShapeLayer * layer1;
@property (nonatomic , strong) CAShapeLayer * layer2;
@property (nonatomic , strong) CADisplayLink * link;

@property (nonatomic , assign) CGFloat cycle;   // 振幅周期

@property (nonatomic, assign) CGFloat offsetX1 ; // x轴的偏移量

@property (nonatomic, assign) CGFloat waveWidth; // 整个波的宽度
@property (nonatomic, assign) CGFloat waveHeight;  // 整个波的高度

@property (nonatomic, assign) CGFloat processWeigth;   // 进度比重

@property (nonatomic, assign) CGFloat proccessBase;    // 容器的每1单位长度的大小为多少个百分比  单位百分比基数

@property (nonatomic, assign) CGFloat speed ;   // 波速

@property (nonatomic, assign) CGFloat  height;   //  占容器的位置

@property (nonatomic, assign) CGFloat  realProcess;   // 真实的百分比

@property (nonatomic, strong) UIView * waveView ;
@property (nonatomic, strong) UILabel * label;



@end

@implementation WaveController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self initProperty];
    [self initViews];
    
    [self startDisPlay];
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
}

-(void)initProperty
{
    self.processWeigth = 0;
    self.height = 0;
    
    self.offsetX1 = 0;
    self.speed = 4;
    
    self.waveWidth =150;
    self.waveHeight = 6;
    
    self.proccessBase = 100 / self.waveWidth ;
    self.cycle = M_PI / self.waveWidth;
    
    self.realProcess = 80;
}

-(void)initViews
{
    self.waveView = [[UIView alloc]initWithFrame:CGRectMake(0, 150,  self.waveWidth, 150)];
    [self.waveView setCenter:self.view.center];
    self.waveView.layer.cornerRadius = 150 / 2;
    self.waveView.layer.masksToBounds = YES;
    [self.waveView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.waveView];
    
    
    self.layer1 = [CAShapeLayer layer];
    self.layer1.frame = CGRectMake(0, CGRectGetHeight(self.waveView.frame), self.waveWidth, CGRectGetHeight(self.waveView.frame) );
    self.layer1.opacity = 0.5;
    [self.waveView.layer addSublayer:self.layer1];
    
    self.layer2 = [CAShapeLayer layer];
    self.layer2.frame = CGRectMake(0, CGRectGetHeight(self.waveView.frame), self.waveWidth, CGRectGetHeight(self.waveView.frame) );
    self.layer2.opacity = 0.5;
    [self.waveView.layer addSublayer:self.layer2];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, self.waveView.frame.size.width, 30)];
    self.label.text = @"0.0%";
    [self.label setTextAlignment: NSTextAlignmentCenter];
    [self.label setFont:[UIFont systemFontOfSize:18.0f]];
    [self.label setTextColor:[UIColor whiteColor]];
    [self.waveView addSubview:self.label];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(200, 80, 50, 50)];
    [btn addTarget:self action:@selector(StartLoad) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)StartLoad
{
    [self initProperty];
}



-(void)getCurrentWave
{
    if(fabs(self.processWeigth) < self.waveView.frame.size.height /100 * self.realProcess)
    {
        self.processWeigth -= 0.2; // 波浪上升高度  系统坐标系 y轴 上小下大
        CGFloat temp = self.proccessBase * fabs(self.processWeigth); //计算 当前上升高度所占的百分比
        [self.label setText:[NSString stringWithFormat:@"%.0f%%",temp]];
    }
    else
    {
//        [self stopDisPlay];
    }
}


// 绘制波浪
-(void)HandleAnimation
{
    [self getCurrentWave];
    
    self.offsetX1 += self.speed;
    //设置起始位置
    CGFloat startY=self.waveHeight * sinf(self.offsetX1* self.cycle);
    CGMutablePathRef  pathRef = CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, NULL, 0, startY);
    for (CGFloat i = 0.0; i < _waveWidth; i ++) {
        
        CGFloat y = self.waveHeight* sinf(2.5 * i/ self.waveWidth + self.offsetX1 *self.cycle) + self.processWeigth;
        CGPathAddLineToPoint(pathRef, NULL, i, y);
    }
    CGPathAddLineToPoint(pathRef, NULL, self.waveWidth, self.height);
    CGPathAddLineToPoint(pathRef, NULL, 0, self.height);
    CGPathCloseSubpath(pathRef);
    //设置第一个波layer的path
    self.layer1.path = pathRef;
    self.layer1.fillColor = [UIColor lightGrayColor].CGColor;
    CGPathRelease(pathRef);
    
    
    CGFloat startY2= self.waveHeight * cosf(self.offsetX1 * self.cycle );
    CGMutablePathRef  pathRef2 = CGPathCreateMutable();
    CGPathMoveToPoint(pathRef2, NULL, 0, startY2);
    
    for (CGFloat x = 0.0; x < _waveWidth; x ++) {
        CGFloat y = self.waveHeight* cosf(2.5 * x/ self.waveWidth + self.offsetX1 * self.cycle) + self.processWeigth;
        CGPathAddLineToPoint(pathRef2, NULL, x, y);
    }
    CGPathAddLineToPoint(pathRef2, NULL, self.waveWidth, self.height);
    CGPathAddLineToPoint(pathRef2, NULL, 0, self.height);
    CGPathCloseSubpath(pathRef2);
    
    //设置第二个波layer的path
    self.layer2.path = pathRef2;
    self.layer2.fillColor = [UIColor blueColor].CGColor;
    CGPathRelease(pathRef2);
}




@end
