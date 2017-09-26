//
//  YSHY2048Cell.m
//  粒子效果
//
//  Created by 杨淑园 on 2017/6/23.
//  Copyright © 2017年 yangshuyaun. All rights reserved.
//

#import "YSHY2048Cell.h"

@implementation YSHY2048Cell

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70 , 70)];
        self.lab.textAlignment = NSTextAlignmentCenter;
        [self.lab setFont:[UIFont systemFontOfSize:30]];
        
        [self addSubview:self.lab];
    }
    return self;
}
-(void)configUI:(YSHY2048Obj *)obj
{
    if(obj.title == 0)
    {
        self.lab.text = @"";
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        NSString *str = [NSString  stringWithFormat:@"%ld",(long)obj.title];
        self.lab.text = str;
       [self.lab setFont:[UIFont systemFontOfSize:30]];
        [self setLabBackGround:obj];
        [self setLabTextColor:obj];
    }
}

-(void)setLabTextColor:(YSHY2048Obj *)obj
{
    if(obj.title == 2 || obj.title == 4)
    {
         self.lab.textColor = [UIColor colorWithRed:76/255.0 green:73/255.0 blue:80/255.0 alpha:1];
    }
    else
    {
        self.lab.textColor = [UIColor whiteColor];
    }
}

-(void)setLabBackGround:(YSHY2048Obj *)obj
{
    UIColor *color;
    if(obj.title == 2)
    {
        color = [UIColor colorWithRed:239/255.0 green:230/255.0 blue:220/255.0 alpha:1];
       
    }else if (obj.title == 4)
    {
        color = [UIColor colorWithRed:239/255.0 green:213/255.0 blue:202/255.0 alpha:1];
    }
    else if (obj.title == 8)
    {
        color = [UIColor colorWithRed:238/255.0 green:190/255.0 blue:186/255.0 alpha:1];
    }
    else if (obj.title == 16)
    {
        color = [UIColor colorWithRed:238/255.0 green:165/255.0 blue:152/255.0 alpha:1];
    }
    else if (obj.title == 32)
    {
         color = [UIColor colorWithRed:238/255.0 green:152/255.0 blue:152/255.0 alpha:1];
        
    }else if (obj.title == 64)
    {
         color = [UIColor colorWithRed:238/255.0 green:152/255.0 blue:116/255.0 alpha:1];
    }
    else if (obj.title == 128)
    {
        color = [UIColor colorWithRed:238/255.0 green:132/255.0 blue:155/255.0 alpha:1];
    }
    else if (obj.title == 256)
    {
        color = [UIColor colorWithRed:238/255.0 green:113/255.0 blue:63/255.0 alpha:1];
    }
    else if (obj.title == 512)
    {
         color = [UIColor colorWithRed:238/255.0 green:95/255.0 blue:63/255.0 alpha:1];
        
    }else if (obj.title == 1024)
    {
        color = [UIColor colorWithRed:238/255.0 green:196/255.0 blue:63/255.0 alpha:1];
    }
    else if (obj.title == 2048)
    {
        [self.lab setFont:[UIFont systemFontOfSize:25]];
         color = [UIColor colorWithRed:238/255.0 green:220/255.0 blue:25/255.0 alpha:1];
    }else
    {
         color = [UIColor colorWithRed:232/255.0 green:247/255.0 blue:34/255.0 alpha:1];
    }
    [self setBackgroundColor:color];
    
}

@end
