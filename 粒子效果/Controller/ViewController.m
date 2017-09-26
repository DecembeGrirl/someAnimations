//
//  ViewController.m
//  粒子效果
//
//  Created by 杨淑园 on 16/5/27.
//  Copyright © 2016年 yangshuyaun. All rights reserved.
//

#import "ViewController.h"
#import "EmitterController.h"
#import "CircleController.h"
#import "WaveController.h"
#import "leavesDropController.h"
#import "labelDiffuseController.h"
#import "WellcomeController.h"
#import "scratchLottoController.h"
#import "switchController.h"
#import "CircleMenuController.h"

#import "YSHY2048ViewController.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong) NSArray * dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
//    self.dataArray = @[@"粒子效果",@"圆形缩放",@"波纹",@"樱花飘落",@"发散标签",@"welCome",@"刮刮乐",@"半圆菜单",@"2048"];
     self.dataArray = @[@"welCome",@"半圆菜单",@"2048"];
    
}
#pragma  maek - tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController * VC ;
//    if(indexPath.row == 0)
//        VC = [[EmitterController alloc]init];
//    else if(indexPath.row == 1)
//        VC = [[CircleController alloc]init];
//    else if(indexPath.row == 2)
//        VC = [[WaveController alloc]init];
//    else if(indexPath.row == 3)
//        VC = [[leavesDropController alloc]init];
//    else if(indexPath.row == 4)
//        VC = [[labelDiffuseController alloc]init];
//    else if(indexPath.row == 5)
//        VC = [[WellcomeController alloc]init];
//    else if(indexPath.row == 6)
//        VC = [[scratchLottoController alloc]init];
//    else if(indexPath.row ==7)
//        VC = [[CircleMenuController alloc]init];
//    else
    
    if(indexPath.row == 0)
    {
        VC = [[WellcomeController alloc]init];
    }
    else if(indexPath.row == 1)
    {
         VC = [[CircleMenuController alloc]init];
    }
    else
    {
        VC =[[YSHY2048ViewController alloc]init];
    }
    [self.navigationController pushViewController:VC animated:YES];
}






@end
