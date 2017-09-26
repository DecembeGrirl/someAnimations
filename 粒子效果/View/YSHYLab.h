//
//  YSHYLab.h
//  粒子效果
//
//  Created by 杨淑园 on 16/6/2.
//  Copyright © 2016年 yangshuyaun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBklock)(BOOL isPause);

@interface YSHYLab : UILabel<UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL isPause;

@property (nonatomic, strong) CAShapeLayer * shapLayer;

@property (nonatomic, copy)SelectedBklock selectedBlock;

-(void)beginAni;
-(void)pausedAni;
-(void)resumeAni;

@end
