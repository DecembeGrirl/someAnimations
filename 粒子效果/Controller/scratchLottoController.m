//
//  scratchLottoController.m
//  粒子效果
//
//  Created by 杨淑园 on 16/6/28.
//  Copyright © 2016年 yangshuyaun. All rights reserved.
//

// 刮刮奖 动画效果
#import "scratchLottoController.h"

@interface scratchLottoController ()
{
    CGImageRef _overImage;     //覆盖图层
    CGImageRef _scratchImage;
    CGContextRef contextMask;
    CGImageRef scratchImage;
    CGPoint currentPoint;
    CGPoint previousPoint;

}
@property (nonatomic, strong) UILabel * label;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) CAShapeLayer * overLayer;


@end

@implementation scratchLottoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.label =[[UILabel alloc]initWithFrame:CGRectMake(100, 200,200, 200)];
    self.label.text = @"喜大普奔";
//    [self.label setBackgroundColor:[UIColor blueColor]];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];
    
    self.imageView = [[UIImageView alloc]initWithFrame:self.label.frame];
    [self.imageView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.imageView];
    
    
//    [self overView];
//    self.overLayer = [CAShapeLayer layer];
//    self.overLayer.fillColor = [UIColor redColor].CGColor;
//    self.overLayer.strokeColor = [UIColor yellowColor].CGColor;
//    self.overLayer.fillRule = kCAFillRuleEvenOdd;
//    self.overLayer.lineCap = kCALineCapRound;
//    self.overLayer.lineJoin = kCALineJoinRound;
//    self.overLayer.lineWidth = 10;
////    UIBezierPath * path = [UIBezierPath bezierPathWithRect:self.label.frame];
////    [path addArcWithCenter:self.label.center radius:150 startAngle:0 endAngle:2*M_PI clockwise:YES];
//    
//    
//    
//    
//    CAShapeLayer * layer  = [CAShapeLayer layer];
//    layer.fillColor = [UIColor yellowColor].CGColor;
//    layer.strokeColor = [UIColor redColor].CGColor;
//    layer.fillRule = kCAFillRuleEvenOdd;
//
////    layer.opacity = 0.5;
//    
//    UIBezierPath * path2 = [UIBezierPath bezierPath];
//    [path2 moveToPoint:CGPointMake(100, 200)];
//    [path2 addLineToPoint:CGPointMake(100, 400)];
//    [path2 addLineToPoint:CGPointMake(300, 400)];
//    [path2 addLineToPoint:CGPointMake(300, 200)];
//    [path2 closePath];
//    
////    [path2 appendPath:[UIBezierPath bezierPathWithArcCenter:self.label.center radius:100 startAngle:0 endAngle:2*M_PI clockwise:NO]];
////    UIBezierPath * path1 = [UIBezierPath bezierPathWithArcCenter:self.label.center radius:100 startAngle:0 endAngle:2*M_PI clockwise:NO];
//    [path2 setUsesEvenOddFillRule:YES];
//    self.overLayer.path = path2.CGPath;
//    layer.path = path2.CGPath;
//    [self.view.layer addSublayer:layer];
//    [self.view.layer addSublayer:self.overLayer];
    
}

-(void)overView
{
    //颜色空间
    CGColorSpaceRef coloSpace = CGColorSpaceCreateDeviceGray();
    
    float scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(self.label.frame.size, NO, 0);
    [self.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.imageView.layer.contentsScale = scale;
    
    _overImage = UIGraphicsGetImageFromCurrentImageContext().CGImage;
    UIGraphicsEndImageContext();
    
    size_t imageWidth = CGImageGetWidth(_overImage);
    size_t imageHeight = CGImageGetHeight(_overImage);
    
    CFMutableDataRef dataRef = CFDataCreateMutable(NULL, imageHeight * imageWidth);
    contextMask = CGBitmapContextCreate(CFDataGetMutableBytePtr(dataRef), imageWidth, imageHeight, 8, imageWidth, coloSpace, kCGImageAlphaNone);
    CGDataProviderRef dataProviderRef = CGDataProviderCreateWithCFData(dataRef);
    
    CGContextSetFillColorWithColor(contextMask, [UIColor blackColor].CGColor);
    CGContextFillRect(contextMask, self.imageView.frame);
    CGContextSetLineWidth(contextMask, 30);
    CGContextSetStrokeColorWithColor(contextMask,[UIColor whiteColor].CGColor);
    CGContextSetLineCap(contextMask, kCGLineCapRound);
    
    CGImageRef mask = CGImageMaskCreate(imageWidth, imageHeight, 8, 8, imageWidth, dataProviderRef, nil, NO);
    scratchImage = CGImageCreateWithMask(_overImage, mask);
    CGImageRelease(mask);
    CGColorSpaceRelease(coloSpace);

}
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
//    [super drawLayer:layer inContext:ctx];
    
    
    
        UIImage * image = [UIImage imageWithCGImage:scratchImage];
    [image drawInRect:self.label.frame];
    
    ////    self.imageView.image = image;
    //
    //    [image drawInRect:self.label.frame];
}

-(void)clearPathFrom:(CGPoint) start to:(CGPoint)end
{
    float scale = [UIScreen mainScreen].scale;
    CGContextMoveToPoint(contextMask, start.x * scale, (self.label.frame.size.height - start.y)* scale)
                         ;
    CGContextAddLineToPoint(contextMask, end.x * scale, (self.label.frame.size.height - end.y)* scale);
    CGContextStrokePath(contextMask);

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch * touch = [touches anyObject];
    
    //    [self Clear:touch];
    //    // 获取触摸的位置
    currentPoint = [touch locationInView:self.imageView];
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch * touch = [touches anyObject];

//    [self Clear:touch];
//    // 获取触摸的位置
    CGPoint point = [touch locationInView:self.imageView];
    // 前一个坐标值
//     previousPoint = [touch previousLocationInView:self.view];
    
//    [self clearPathFrom:previousPoint to:currentPoint];
////    // 设置清除点的大小
    CGRect rect = CGRectMake(point.x - 5, point.y - 5, 10, 10);
    UIGraphicsBeginImageContextWithOptions(self.imageView.frame.size, NO, 0);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    [self.imageView.layer renderInContext:ref];
//    CGImageRef contextMask = CGBitmapContextCreateImage(ref);

    CGContextClearRect(ref, rect);
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.imageView.image = image;

    [self.imageView setBackgroundColor:[UIColor clearColor]];
    
    // 颜色空间
//    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceGray();
    //	int bitmapByteCount;
    //	int bitmapBytesPerRow;
    
//    float scale = [UIScreen mainScreen].scale;
    
//    UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, NO, 0);
//    [self.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    self.imageView.layer.contentsScale = scale;
    
//    CGImageRef hideImage = UIGraphicsGetImageFromCurrentImageContext().CGImage;
//    UIGraphicsEndImageContext();
////
//    size_t imageWidth = CGImageGetWidth(hideImage);
//    size_t imageHeight = CGImageGetHeight(hideImage);
//
//    	bitmapBytesPerRow = (imageWidth * 4);
//    	bitmapByteCount = (bitmapBytesPerRow * imageHeight);
    
//    CFMutableDataRef pixels = CFDataCreateMutable(NULL, imageWidth * imageHeight);
//   CGContextRef contextMask = CGBitmapContextCreate(CFDataGetMutableBytePtr(pixels), imageWidth, imageHeight , 8, imageWidth, colorspace, kCGImageAlphaNone);
    
    
//    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData(pixels);
//    
//    CGContextSetFillColorWithColor(contextMask, [UIColor blackColor].CGColor);
//    CGContextFillRect(contextMask, self.imageView.frame);
//    
//    CGContextSetStrokeColorWithColor(contextMask, [UIColor whiteColor].CGColor);
//    CGContextSetLineWidth(contextMask, 10);
//    CGContextSetLineCap(contextMask, kCGLineCapRound);
//    
//    CGImageRef mask = CGImageMaskCreate(imageWidth, imageHeight, 8, 8, imageWidth, dataProvider, nil, NO);
//     CGImageRef scratchImage = CGImageCreateWithMask(hideImage, mask);
//
//    CGImageRelease(mask);
//    CGColorSpaceRelease(colorspace);
//    self.imageView.image = [UIImage imageWithCGImage:scratchImage];
    
//    float scale = [UIScreen mainScreen].scale;
    
//    CGContextMoveToPoint(contextMask, previousTouchLocation.x * scale, (self.imageView.frame.size.height - previousTouchLocation.y) * scale);
//    CGContextAddLineToPoint(contextMask, point.x * scale, point.y * scale);
//    CGContextStrokePath(ref);
    
//    [self.imageView setBackgroundColor:[UIColor clearColor]];
}


-(void)Clear:(UITouch *)touch
{
//    UIView * view = touch.view;
    
    CGPoint  startPoint = [touch locationInView:self.view];
    CGPoint  previousPoint  = [touch previousLocationInView:self.view];
    
    UIBezierPath  *pathRef = [UIBezierPath bezierPathWithCGPath:self.overLayer.path];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.fillColor =[UIColor orangeColor].CGColor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.lineWidth = 10;
    layer.lineJoin = kCALineJoinRound;
    layer.lineCap = kCALineCapRound;
    UIBezierPath * path = [UIBezierPath bezierPath];
    if(!CGPointEqualToPoint(previousPoint, CGPointZero) && !CGPointEqualToPoint(startPoint, CGPointZero))
    {
        [pathRef moveToPoint:previousPoint];
        [pathRef addLineToPoint:startPoint];
//        [path moveToPoint:previousPoint];
//        [path addLineToPoint:startPoint];
//        [path strokeWithBlendMode:kCGBlendModeClear alpha:1.0];
    }
//    [pathRef appendPath:path];

//    layer.path = path.CGPath;
    self.overLayer.path = pathRef.CGPath;
    
}


@end
