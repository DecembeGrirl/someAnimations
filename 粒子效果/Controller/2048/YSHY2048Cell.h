//
//  YSHY2048Cell.h
//  粒子效果
//
//  Created by 杨淑园 on 2017/6/23.
//  Copyright © 2017年 yangshuyaun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSHY2048Obj.h"
@interface YSHY2048Cell : UICollectionViewCell
@property(strong,nonatomic) UILabel * lab;

-(void)configUI:(YSHY2048Obj *)obj;
@end
