//
//  RotateSelectedView.h
//  ScratchableLatex
//
//  Created by 杨淑园 on 16/8/5.
//  Copyright © 2016年 yangshuyaun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RotateSelectedView : UIView
{
    UIButton *centerBtn;
    CGPoint  lastCenter;
    CGFloat  lastPointX;    // 记录 移动的X方向上的位置
    NSMutableArray *btnArray;
    NSMutableArray *angleArray;   // 记录每个Btn所在的角度
    
    UIView * circlePathView;
    CAShapeLayer *myLayer;
    
    NSInteger selecetdIndex;
    CGPoint selecetdCenterPoint;
    CGRect  selecetdCenterFrame;;
}
@property (nonatomic, assign)CGFloat R;    //  大圆与小圆的圆心距离
@property (nonatomic, assign)CGFloat angle;     //  圆心夹角
@property (nonatomic, assign)BOOL btnIsShow;
@property (nonatomic, assign)CGFloat centerRadius;
@property (nonatomic, assign)CGFloat littleBtnRadius;
@property (nonatomic, assign)CGFloat distance;    // 中心圆和小圆的间距

-(void)ConfigUI;
@end
