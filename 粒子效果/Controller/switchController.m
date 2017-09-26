//
//  switchController.m
//  粒子效果
//
//  Created by 杨淑园 on 16/6/29.
//  Copyright © 2016年 yangshuyaun. All rights reserved.
//

#import "switchController.h"
@interface switchController ()

@end

@implementation switchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建一个父亲视图
    _parentView = [[UIView alloc]initWithFrame:CGRectMake(40, 80, 260, 380)];
    [self.view addSubview:_parentView];
    [_parentView setBackgroundColor:[UIColor orangeColor]];
    
    
    _imageView01  = [[UIImageView alloc]initWithFrame:_parentView.frame];
    [_imageView01 setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_imageView01];
    
    _imageView02  = [[UIImageView alloc]initWithFrame:_parentView.frame];
    [_imageView02 setBackgroundColor:[UIColor blueColor]];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self aniMove];

}

-(void)aniMove
{

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
