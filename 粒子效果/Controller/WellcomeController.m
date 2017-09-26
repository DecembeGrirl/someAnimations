//
//  WellcomeController.m
//  粒子效果
//
//  Created by 杨淑园 on 16/6/23.
//  Copyright © 2016年 yangshuyaun. All rights reserved.
//

#import "WellcomeController.h"
#import "AniView.h"
@interface WellcomeController ()

@property (nonatomic, strong)AniView * aniView ;

@end

@implementation WellcomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.aniView = [[AniView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.aniView];
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setFrame:CGRectMake(10, 100, 50, 25)];
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(beginAni) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)beginAni
{
    [self.aniView removeLayer];
    [self.aniView CreatCircleLayer];
}

@end
