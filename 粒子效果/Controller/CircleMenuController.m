//
//  CircleMenuController.m
//  粒子效果
//
//  Created by 杨淑园 on 2017/4/28.
//  Copyright © 2017年 yangshuyaun. All rights reserved.
//

#import "CircleMenuController.h"
#import "YSHYQuarterCircleMenu.h"
#import "RotateSelectedView.h"
@interface CircleMenuController ()

@end

@implementation CircleMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;

    YSHYQuarterCircleMenu * view = [[YSHYQuarterCircleMenu alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 200)];
    view.centerRadius = 50;
    view.littleBtnRadius = 20;
    view.distance = 30;
    [view setBackgroundColor:[UIColor redColor]];
    [view ConfigUI];
    [self.view addSubview:view];
    
    RotateSelectedView * view1 = [[RotateSelectedView alloc]initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 300)];
    view1.centerRadius = 55;
    view1.littleBtnRadius = 25;
    view1.distance = 20;
    [view1 setBackgroundColor:[UIColor redColor]];
    [view1 ConfigUI];
    [self.view addSubview:view1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
