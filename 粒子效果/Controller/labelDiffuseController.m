//
//  labelDiffuseController.m
//  粒子效果
//
//  Created by 杨淑园 on 16/6/2.
//  Copyright © 2016年 yangshuyaun. All rights reserved.
//

//发散标签

#import "labelDiffuseController.h"
#import "YSHYLab.h"
@interface labelDiffuseController ()
@property (nonatomic, strong) UILabel * label;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSTimer * timer;
//@property (nonatomic, assign) CGPoint  lastPoint;
@property (nonatomic, assign) CGPathRef  lastRect;

@property (nonatomic, assign) BOOL isStop;
@end

@implementation labelDiffuseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    self.dataArray = @[@"魔兽",@"惊天魔盗团",@"X战警:天启",@"爱丽诗梦游仙境2",@"愤怒的小鸟",@"美国队长3",@"白毛女",@"分歧者3:忠诚世界",@"百鸟朝凤",@"我的少女时代",@"火锅英雄",@"疯狂动物城",@"功夫熊猫3",@"海底总动员2:寻找多莉"];
    
    self.count = 0;
    self.lastRect  = CGPathCreateWithRect(CGRectZero, NULL);
//    self.lastRect = CGPathCreateMutableCopy()
    [self.timer fire];
}

-(NSTimer *)timer
{
    if(!_timer)
    {
        _timer =[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(CreateLabel) userInfo:nil repeats:YES];
    }
    return _timer;
}

-(CGPoint)getCenter
{
    CGFloat centerX = (100 + (arc4random()% (260 - 100 + 10)));
    CGFloat centerY = (100 + (arc4random() % (280 - 100 + 10)));

    return CGPointMake(centerX, centerY);
}

-(void)CreateLabel
{
    
    if(self.count >= self.dataArray.count)
    {
        self.count =0;
        return;
    }
    
    CGPoint point;
    do {
        point = [self getCenter];
    } while (CGPathContainsPoint(self.lastRect, NULL, point, NO));
    
    YSHYLab *label = [[YSHYLab alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    [label setCenter:point];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.text = self.dataArray[self.count];
    
   CGRect rect =  [label.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0] ,NSFontAttributeName, nil] context:nil];
    CGRect frame = label.frame;
    frame.size.width = ceil(rect.size.width);
    label.frame  = frame;
    
    label.alpha = 0.3;
    [self.view addSubview:label];
    [self.view sendSubviewToBack:label];
    [label beginAni];
    
    __weak typeof(self)weakSelf = self;
//    label.selectedBlock = ^(BOOL isPause)
//    {
//        NSLog(@" -==-=-=    %ld",isPause);
//        if(!isPause)
//           [weakSelf StopAllLabelAni];
//        else
//            [weakSelf resumeAllAni];
//        
//        
//        weakSelf.isStop = !weakSelf.isStop;
//    };
    
    self.count ++;
//    if(self.count >= self.dataArray.count)
//        self.count =0;
}

-(void)StopAllLabelAni
{
    NSLog(@"停下了");
    self.isStop = YES;
    [self.timer invalidate];
    self.timer = nil;
    for (int i = 0; i < self.view.subviews.count; i++) {
        YSHYLab * label = self.view.subviews[i];
        label.isPause = YES;
        [label pausedAni];
    }
}

-(void)resumeAllAni
{
     NSLog(@"恢复了");
    self.isStop = NO;
    [self.timer fire];
    for (int i = 0; i < self.view.subviews.count; i++) {
        YSHYLab * label = self.view.subviews[i];
        label.isPause = NO;
        [label resumeAni];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if([touches.anyObject.view isKindOfClass:[YSHYLab class]])
    {
        YSHYLab * label =( YSHYLab *) touches.anyObject.view;
        NSLog(@"点击了 %@", label.text);
        label.isPause?[self resumeAllAni]:[self StopAllLabelAni];
    }
    else if(self.isStop)
    {
        [self resumeAllAni];
    }
}




@end
