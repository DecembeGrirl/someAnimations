//
//  YSHY2048Obj.m
//  粒子效果
//
//  Created by 杨淑园 on 2017/6/23.
//  Copyright © 2017年 yangshuyaun. All rights reserved.
//

#import "YSHY2048Obj.h"

@implementation YSHY2048Obj

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.x forKey:@"x"];
    [aCoder encodeInteger:self.y  forKey:@"y"];
    [aCoder encodeInteger:self.title forKey:@"title"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self) {
        self.x = [aDecoder decodeIntForKey:@"x"];
        self.y = [aDecoder decodeIntForKey:@"y"];
        self.title = [aDecoder decodeIntForKey:@"title"] ;
    }
    return self;
}


@end
