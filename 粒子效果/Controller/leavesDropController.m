//
//  leavesDropController.m
//  粒子效果
//
//  Created by 杨淑园 on 16/6/1.
//  Copyright © 2016年 yangshuyaun. All rights reserved.
//

#import "leavesDropController.h"

@interface leavesDropController ()
@property (nonatomic, strong)CAEmitterLayer * layer;
@property (nonatomic, strong)UIImageView * imageView;

@end

@implementation leavesDropController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [imageView setImage:[UIImage imageNamed:@"樱花树1"]];
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    
    CAEmitterLayer * layer = [CAEmitterLayer layer];
    layer.frame = imageView.frame;
    
    layer.emitterPosition = CGPointMake(self.view.frame.size.width / 2, -50);
    layer.emitterSize = CGSizeMake(self.view.frame.size.width * 2, 0);
    
    layer.emitterMode = kCAEmitterLayerOutline;
    layer.emitterShape = kCAEmitterLayerLine;
    
    CAEmitterCell * cell = [CAEmitterCell emitterCell];
    cell.contents = (__bridge id)[UIImage imageNamed:@"樱花瓣2"].CGImage;
    
    cell.scale = 0.03;
    cell.scaleRange = 0.5;
    
    cell.birthRate = 10;
    cell.lifetime = 50;
    
    cell.alphaSpeed = 0.01;
    
    cell.velocity = 50;
    cell.velocityRange = 60;
    
    // cell 掉落的速度
    cell.emissionRange = M_PI;
    
    //cell旋转的速度
    cell.spin = M_PI_4;
    
    layer.shadowColor = [UIColor whiteColor].CGColor;
    layer.shadowOffset = CGSizeMake(3, 3);
    layer.shadowOpacity = 1;
    layer.shadowRadius = 7;

    layer.emitterCells = [NSArray arrayWithObject:cell];
    
    self.layer = layer;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.imageView.layer addSublayer:self.layer];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.layer removeFromSuperlayer];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
}




@end
