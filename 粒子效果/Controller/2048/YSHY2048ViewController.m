//
//  2048ViewController.m
//  粒子效果
//
//  Created by 杨淑园 on 2017/6/23.
//  Copyright © 2017年 yangshuyaun. All rights reserved.
//

#import "YSHY2048ViewController.h"
#import "EqualSpaceFlowLayout.h"
#import "YSHY2048Obj.h"
#import "YSHY2048Cell.h"
@interface YSHY2048ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,EqualSpaceFlowLayoutDelegate,UIGestureRecognizerDelegate>
{
    UICollectionView * myCollectionView;
    NSMutableArray * dataArray;
    NSMutableArray * visibales;
    
    NSInteger myDirection;   // 滑动的方向
    
    NSInteger score;
    NSInteger bestScore;
    NSInteger targetScore;
    UILabel * scoreLab;
    UILabel * bestScoreLab;
    UILabel * tipLab;
}
@end

@implementation YSHY2048ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    //设置collectionView的属性
//    [self getCacheData];
//    if(dataArray.count ==0)
//    {
        [self initData];
//    }
    
    [self setConfigView];
    [self initMainView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self saveData];
}
-(void)initMainView
{
    EqualSpaceFlowLayout * flowLayout = [[EqualSpaceFlowLayout alloc]init];
    
    flowLayout = [[EqualSpaceFlowLayout alloc]init];
    flowLayout.delegate = self;
    //布局方向
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 0, 0);
    //    flowLayout.itemSize = self.collectionView.bounds.size;    //关闭弹簧
    CGRect frame = CGRectMake(10,200, self.view.frame.size.width -20,self.view.frame.size.width-20);
    myCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    myCollectionView.layer.cornerRadius = 5;
    myCollectionView.layer.masksToBounds = YES;
    [myCollectionView setBackgroundColor:[UIColor colorWithRed:187/255.0 green:174/255.9 blue:162/255.0 alpha:1]];
    [self.view addSubview:myCollectionView];
    myCollectionView.bounces = NO;
    //设置分页
    myCollectionView.pagingEnabled = YES;
    myCollectionView.dataSource = self;
    myCollectionView.delegate = self;
    //注册collectionView
    [myCollectionView registerClass:[YSHY2048Cell class] forCellWithReuseIdentifier:@"GoodsDataItemCell"];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panSelected:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
}

-(void)setConfigView
{
    UILabel * logoLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 25, 120, 120)];
    [self.view addSubview:logoLab];
    [logoLab setBackgroundColor:[UIColor colorWithRed:238/255.0 green:220/255.0 blue:25/255.0 alpha:1]];
    logoLab.text = @"2048";
    logoLab.layer.cornerRadius = 5;
    logoLab.layer.masksToBounds = YES;
    logoLab.textColor = [UIColor whiteColor];
    logoLab.textAlignment = NSTextAlignmentCenter;
    [logoLab setFont:[UIFont systemFontOfSize:28 weight:10]];
    
    scoreLab = [[UILabel alloc]initWithFrame:CGRectMake(150, 25, 90, 70)];
    [self.view addSubview:scoreLab];
    scoreLab.layer.cornerRadius = 5;
    scoreLab.layer.masksToBounds = YES;
    scoreLab.numberOfLines =2;
    [scoreLab setBackgroundColor:[UIColor colorWithRed:187/255.0 green:174/255.9 blue:162/255.0 alpha:1]];
    scoreLab.text = [NSString stringWithFormat:@"分数\n%ld",(long)score];
    scoreLab.textColor = [UIColor whiteColor];
    scoreLab.textAlignment = NSTextAlignmentCenter;
    [scoreLab setFont:[UIFont systemFontOfSize:15]];
    
    bestScoreLab = [[UILabel alloc]initWithFrame:CGRectMake(255, 25, 90, 70)];
    [self.view addSubview:bestScoreLab];
    bestScoreLab.layer.cornerRadius = 5;
    bestScoreLab.layer.masksToBounds = YES;
    bestScoreLab.numberOfLines =2;
    [bestScoreLab setBackgroundColor:[UIColor colorWithRed:187/255.0 green:174/255.9 blue:162/255.0 alpha:1]];
    bestScoreLab.text = [NSString stringWithFormat:@"历史最高分数\n%ld",(long)bestScore];
    bestScoreLab.textColor = [UIColor whiteColor];
    bestScoreLab.textAlignment = NSTextAlignmentCenter;
    [bestScoreLab setFont:[UIFont systemFontOfSize:13]];
    
    UIButton * menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuBtn setFrame:CGRectMake(150, 110, 90, 30)];
    menuBtn.layer.cornerRadius = 5;
    menuBtn.layer.masksToBounds = YES;
    [menuBtn setBackgroundColor:[UIColor colorWithRed:238/255.0 green:113/255.0 blue:63/255.0 alpha:1]];
    [menuBtn setTitle:@"菜单" forState:UIControlStateNormal];
    [menuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(selectMenuBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuBtn];
    
    UIButton * bestScrolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bestScrolBtn.layer.cornerRadius = 5;
    bestScrolBtn.layer.masksToBounds = YES;
    [bestScrolBtn setFrame:CGRectMake(255, 110, 90, 30)];
    [bestScrolBtn setTitle:@"排行榜" forState:UIControlStateNormal];
    [bestScrolBtn setBackgroundColor:[UIColor colorWithRed:238/255.0 green:113/255.0 blue:63/255.0 alpha:1]];
    [bestScrolBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:bestScrolBtn];
    
    tipLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 160, self.view.frame.size.width -5, 25)];
    [self.view addSubview:tipLab];
    tipLab.layer.cornerRadius = 5;
    tipLab.layer.masksToBounds = YES;
    tipLab.numberOfLines =2;
    targetScore =!targetScore?2048:targetScore;
    tipLab.text = [NSString stringWithFormat:@"您的新挑战是获得%ld方块!",(long)targetScore];
    tipLab.textColor = [UIColor colorWithRed:187/255.0 green:174/255.9 blue:162/255.0 alpha:1];
    [tipLab setFont:[UIFont systemFontOfSize:20 weight:8]];
}

#pragma mark -- collectionView代理数据源方法
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 16;
    
}
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YSHY2048Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsDataItemCell" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor redColor]];
    [cell configUI:dataArray[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 70);
}
-(void)panSelected:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation = [gesture translationInView:self.view];
    myDirection = [self direction:translation];
    if(gesture.state == UIGestureRecognizerStateEnded)
    {
        if(myDirection == 1)
        {
            if([self isCanRigthSwip])
            {
                [self swipRight];
                [self reShowView];
            }
        }
        else if(myDirection == 2)
        {
            if([self isCanLeftSwip])
            {
                [self swipLeft];
                [self reShowView];
            }
        }else if(myDirection == 3)
        {
            if([self isCanDownSwip])
            {
                [self swipDown];
                [self reShowView];
            }
            
        }else if(myDirection == 4)
        {
            if([self isCanUpSwip])
            {
                [self swipUp];
                [self reShowView];
            }
        }
       
    }
}
-(void)reShowView
{
    NSLog(@"**************************");
    for (int i = 0; i < 4; i++) {
        
        YSHY2048Obj * obj = dataArray[i*4];
        YSHY2048Obj * obj1 = dataArray[i*4+1];
        YSHY2048Obj * obj2 = dataArray[i*4+2];
        YSHY2048Obj * obj3 = dataArray[i*4+3];
        NSLog(@"%ld  %ld  %ld  %ld",(long)obj.title,(long)obj1.title,(long)obj2.title,(long)obj3.title);
    }
    NSLog(@"**************************");
    [myCollectionView reloadData];
    
   
    [self performSelector:@selector(nextShow) withObject:nil afterDelay:0.1];
}

-(NSInteger)direction:(CGPoint)translate
{
    CGFloat dx = translate.x;
    CGFloat dy = translate.y;
    
    CGFloat ABSdx = fabs(dx);
    CGFloat ABSdy = fabs(dy);
    
    if(ABSdx > ABSdy && dx > 0 )  //  向右滑动
    {
        return 1;
    }else  if(ABSdx > ABSdy && dx < 0 )  // 向左滑动
    {
        return 2;
    }
    
    if(ABSdx < ABSdy && dy > 0 )  //  向下滑动
    {
        return 3;
    }else  if(ABSdx < ABSdy && dy < 0 )  // 向上滑动
    {
        return 4;
    }
    
    return 0;
}

-(void)initData
{
    score = 0;
    dataArray = [NSMutableArray arrayWithCapacity:16];
    for (int i = 0; i < 4; i ++) {
        for(int j = 0;j < 4;j++)
        {
            YSHY2048Obj * obj = [[YSHY2048Obj alloc]init];
            obj.x = i;
            obj.y = j;
            obj.title = 0;
            [dataArray addObject:obj];
        }
    }
    visibales = [dataArray mutableCopy];
    [myCollectionView reloadData];
//    0  0  0  2
//    0  0  0  0
//    0  0  8  2
//    4  16  2  8
    
    YSHY2048Obj * obj = dataArray[3];
    obj.title = 2;
    YSHY2048Obj * obj1 = dataArray[10];
    obj1.title = 8;
    YSHY2048Obj * obj2 = dataArray[11];
    obj2.title = 2;
    YSHY2048Obj * obj3 = dataArray[12];
    obj3.title = 4;
    YSHY2048Obj * obj4 = dataArray[13];
    obj4.title = 16;
    YSHY2048Obj * obj5 = dataArray[14];
    obj5.title = 2;
    YSHY2048Obj * obj6 = dataArray[15];
    obj6.title = 8;
    [visibales removeObject:obj];
    [visibales removeObject:obj1];
    [visibales removeObject:obj2];
    [visibales removeObject:obj3];
    [visibales removeObject:obj4];
    [visibales removeObject:obj5];
    [visibales removeObject:obj6];
    
//    [self nextShow];
//    [self nextShow];
}

#pragma  mark  --   是否可以滑动
-(BOOL)isCanRigthSwip{
    for (int k = 0; k < 4; k++) {
        // 确定 i 的范围
        for (int i =  k*4 + 3 - 1; i >= k*4; i++) {
            YSHY2048Obj * obj1 = dataArray[i];
            YSHY2048Obj *obj2 = dataArray[i+1];
            if([self isCanSwipObj1:obj1 obj2:obj2])
            {
                NSLog(@"------能够向右滑");
                return YES;
            }
        }
    }
    NSLog(@"------不能够向右滑");
    return NO;
}
-(BOOL)isCanLeftSwip{
    int k = 0;
    for (k = 0; k < 4; k++) {
        // 确定 i 的范围
        for (int i = k*4+1; i < k*4 + 4; i++) {
            YSHY2048Obj * obj1 = dataArray[i];
            YSHY2048Obj *obj2 = dataArray[i-1];
            if([self isCanSwipObj1:obj1 obj2:obj2])
            {
                NSLog(@"------能够向左滑");
                return YES;
            }
        }
    }
    NSLog(@"------bu能够向左滑");
    return NO;
}

// 判断 是否可以向上滑动
-(BOOL)isCanUpSwip{
    int k = 0;
    while (k < 4 ){
        int i =  k + 4;
        while(i <= 3*4+k) {
            YSHY2048Obj * obj1 = dataArray[i];
            YSHY2048Obj *obj2 = dataArray[i-4];
            if([self isCanSwipObj1:obj1 obj2:obj2])
            {
                return YES;
            }
            i += 4;
        }
        k += 1;
    }
    NSLog(@"------不能够向上滑");
    return NO;
}
// 判断 是否可以向下滑动
-(BOOL)isCanDownSwip{
    int k = 0;
    while (k < 4) {
        int i = 2*4 + k;
        while  (i >= k) {
            YSHY2048Obj * obj1 = dataArray[i];
            YSHY2048Obj *obj2 = dataArray[i+4];
            if([self isCanSwipObj1:obj1 obj2:obj2])
            {
                return YES;
            }
            i -= 4;
        }
        k += 1;
    }
    NSLog(@"------不能够向下滑");
    return NO;
}


-(BOOL)isCanSwipObj1:(YSHY2048Obj*)obj1 obj2:(YSHY2048Obj *)obj2 {
    if ((obj1.title != 0 && obj2.title == 0) || (obj1.title == obj2.title && obj1.title != 0 && obj2.title != 0 )){
        return YES;
    }
    else{
        return NO;
    }
}

-(void)swipRight{
    for (int k = 0; k < 4; k ++) {
        // 确定 i 的范围
        for (int i = k*4+4 -1; i >=k*4 ; i--) {
         
            for (int j = i -1; j >= k*4; j--) {
                YSHY2048Obj * obj1 = dataArray[i];
                YSHY2048Obj *obj2 = dataArray[j];
                if([self exchangePositionObj1:obj1 obj2:obj2])
                {
                    break;
                }
            }
        }
    }
}

-(void)swipLeft{
    for (int k = 0; k < 4; k++) {
        // 确定 i 的范围
        for (int i = k*4; i < k*4 + 4; i++) {
            for (int j = i+1; j < k*4 +4; j++) {
                YSHY2048Obj * obj1 = dataArray[i];
                YSHY2048Obj *obj2 = dataArray[j];
                if([self exchangePositionObj1:obj1 obj2:obj2])
                {
                    break;
                }
            }
        }
    }
}

-(void)swipUp{
    int k = 0;
    while (k < 4 ){
        int i =  k;
        while (i <= 3*4+k) {
            int j = i + 4;
            while (j <= 3*4+k) {
                YSHY2048Obj * obj1 = dataArray[i];
                YSHY2048Obj *obj2 = dataArray[j];
                if([self exchangePositionObj1:obj1 obj2:obj2])
                {
                    break;
                }
                j += 4;
            }
            i += 4;
        }
        k += 1;
    }
}

-(void)swipDown{
    int k = 0;
    while (k < 4) {
        int i = 3*4 + k;
        while (i > 0) {
            int  j = i - 4;
            while (j >= 0) {
                YSHY2048Obj * obj1 = dataArray[i];
                YSHY2048Obj *obj2 = dataArray[j];
               if([self exchangePositionObj1:obj1 obj2:obj2])
               {
                   break;
               }
                j -= 4;
            }
            i -= 4;
        }
        k += 1;
    }
}

-(BOOL)exchangePositionObj1:(YSHY2048Obj *)obj1 obj2:(YSHY2048Obj*)obj2{
    
    if (obj1.title == 0  && obj2.title != 0){
        NSLog(@" 查看 可用的 visibales");
        for (int i = 0; i< visibales.count; i++)
        {
            YSHY2048Obj * obj = visibales[i];
            NSLog(@"%ld  %ld  %ld",obj.x,obj.y,obj.title);
        }
        
        [visibales removeObject:obj1];
        obj1.title = obj2.title;
        obj2.title = 0;
        [visibales addObject:obj2];
        NSLog(@"++++++++++++");
        for (int i = 0; i< visibales.count; i++)
        {
            YSHY2048Obj * obj = visibales[i];
            NSLog(@"%ld  %ld  %ld",obj.x,obj.y,obj.title);
        }
    }
    else if(obj1.title == obj2.title && obj1.title != 0 && obj2.title != 0)
    {
        obj1.title = obj1.title  * 2;
        obj2.title = 0;
        [visibales addObject:obj2];
        score += obj1.title;
        bestScore = score > bestScore ?score: bestScore;
        [self setLabText];
        if(bestScore >= targetScore)
        {
            targetScore = targetScore * 2;
            tipLab.text = [NSString stringWithFormat:@"您的新挑战是获得%ld方块",targetScore];
        }
        return YES;
    }
    else if (obj1.title != 0 && obj2.title != 0 && obj1.title != obj2.title)
    {
        return YES;
    }
    return NO;
}


//-(void)swipRight
//{
//    int i = 0;
//    while (i < 4) {
//        // 先将调整数据,将 所有的空的 格子 按着从左到右的方向排序
//        [self moveLastObjToCurrentPostition:i];
//        // 合并相同的单元格
//        int j = (i+1)*4 -1;
//        for (; j > 4*i; j--) {
//            YSHY2048Obj * obj = dataArray[j-1];
//            YSHY2048Obj * nextObj = dataArray[j];
//            [self centerArithmenticharWith:obj nextObj:nextObj];
//        }
//        [self moveLastObjToCurrentPostition:i];
//        i++;
//    }
//}
//-(void)swipLeft
//{
//    int i = 0;
//    while (i < 4) {
//        [self moveLastObjToCurrentPostition:i];
//        int j = i*4;
//        for (; j < 4*(i+1) -1; j++) {
//            YSHY2048Obj * obj = dataArray[j];
//            YSHY2048Obj * nextObj = dataArray[j+1];
//            [self centerArithmenticharWith:nextObj nextObj:obj ];
//        }
//        [self moveLastObjToCurrentPostition:i];
//        i++;
//    }
//}
//-(void)swipUp
//{
//    int i = 0;
//    while (i < 4) {
//        [self moveLastObjToCurrentPostition:i];
//        int j  = i;      // 因为 向下有四行    第四行 最右边为12
//        for (; j < 4*3 +i; j+=4) {
//            YSHY2048Obj * obj = dataArray[j];
//            YSHY2048Obj * nextObj = dataArray[j+4];
//            [self centerArithmenticharWith:obj nextObj:nextObj];
//        }
//        [self moveLastObjToCurrentPostition:i];
//        i++;
//    }
//}
//-(void)swipDown
//{
//    int i = 0;
//    while (i < 4) {
//        [self moveLastObjToCurrentPostition:i];
//        int j  = 4*3 +i;      // 因为 向下有四行    第四行 最右边为12
//        for (; j > i; j -= 4) {
//            YSHY2048Obj * obj = dataArray[j];
//            YSHY2048Obj * nextObj = dataArray[j-4];
//            [self centerArithmenticharWith:obj nextObj:nextObj];
//        }
//        [self moveLastObjToCurrentPostition:i];
//        i++;
//    }
//}

-(void)nextShow{
    
    if(visibales.count <=0)
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"游戏结束" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"重新开始" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self reStart];
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSLog(@" 下一个数字显示的位置 ");
    for (int i = 0; i< visibales.count; i++)
    {
        YSHY2048Obj * obj = visibales[i];
        NSLog(@"%ld  %ld  %ld",obj.x,obj.y,obj.title);
    }
    
    
    // 在可现实的数组 获取下一个显示数字
    NSInteger index= (arc4random() % visibales.count);
    NSInteger title = arc4random() % 1 > 0.7?4:2;
    
    YSHY2048Obj * obj = visibales[index];
    
    // 获取 显示的数据 在数据源的位置
    NSInteger tempIndex = [dataArray indexOfObject:obj];
    
    obj.title = title;
    [visibales removeObject:obj];
    [myCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:tempIndex inSection:0]]];
}

-(BOOL)centerArithmenticharWith:(YSHY2048Obj *)obj  nextObj:(YSHY2048Obj *)nextObj
{
    
    if(obj.title !=0 && nextObj.title !=0 && obj.title== nextObj.title)
    {
        [visibales removeObject:obj];
        obj.title = 0;
        nextObj.title = nextObj.title*2;
        [visibales addObject:obj];
        score += nextObj.title;
        if(nextObj.title == targetScore)
        {
            targetScore = targetScore*2;
            tipLab.text =[NSString stringWithFormat:@"您的新挑战是获得%ld方块!",(long)targetScore];
        }
        [self configScore];
        return YES;
        
    }
    return NO;
}

-(void)moveLastObjToCurrentPostition:(NSInteger)row
{
    if(myDirection == 1)
    {
        NSInteger startIndex = row  * 4 ;
        NSInteger index = (row+1)*4-1;
        for (; index > startIndex  ; index-- ) {
            for (NSInteger i = index -1 ;i >=startIndex;i--)
            {
                YSHY2048Obj *obj = dataArray[index];
                YSHY2048Obj *currentObj = dataArray[i];
                if(obj.title == 0 && currentObj.title !=0)
                {
                    [visibales removeObject:obj];
                    obj.title = currentObj.title;
                    currentObj.title = 0;
                    [visibales addObject:currentObj];
                    break;
                }
            }
        }
        
        
    }
    else if(myDirection == 2)
    {
        //从第一个开始对比
        NSInteger stratIndex = row * 4 ;
        NSInteger index = stratIndex  ;
        NSInteger endIndex =  (row+1) *4  ;
        
        for (; index < endIndex  ; index++ ) {
            for (NSInteger i = index + 1 ;i < endIndex;i++)
            {
                YSHY2048Obj *obj = dataArray[index];
                YSHY2048Obj *currentObj = dataArray[i];
                if(obj.title == 0 && currentObj.title !=0)
                {
                    [visibales removeObject:obj];
                    obj.title = currentObj.title;
                    currentObj.title = 0;
                    [visibales addObject:currentObj];
                    break;
                }
            }
        }
    }
    else if(myDirection == 3)  // 向下滑动
    {
        //从最后一个开始对比
        NSInteger startIndex = row  ;
        NSInteger index = 3*4 + row ;
        for (; index >= startIndex  ; index -= 4 ) {
            for (NSInteger i = index - 4 ;i >= startIndex;i -=4)
            {
                YSHY2048Obj *obj = dataArray[index];
                YSHY2048Obj *currentObj = dataArray[i];
                if(obj.title == 0 && currentObj.title !=0)
                {
                    [visibales removeObject:obj];
                    obj.title = currentObj.title;
                    currentObj.title = 0;
                    [visibales addObject:currentObj];
                    break;
                }
            }
        }
    }
    else if(myDirection ==4)  // 向上滑动
    {
        //从第一个开始对比
        NSInteger startIndex = row ;
        NSInteger index = startIndex;
        NSInteger endIndex = 3*4 + row ;
        for (; index < endIndex  ; index += 4 ) {
            for (NSInteger i = index + 4 ;i <= endIndex;i +=4)
            {
                YSHY2048Obj *obj = dataArray[index];
                YSHY2048Obj *currentObj = dataArray[i];
                if(obj.title == 0 && currentObj.title !=0)
                {
                    [visibales removeObject:obj];
                    obj.title = currentObj.title;
                    currentObj.title = 0;
                    [visibales addObject:currentObj];
                    break;
                }
            }
        }
    }
}

-(void)moveObjeFromIndex:(NSInteger)currentIndex to:(NSInteger)index;
{
    YSHY2048Obj *obj = dataArray[index];
    YSHY2048Obj *currentObj = dataArray[currentIndex];
    if(obj.title == 0 && currentObj.title !=0)
    {
        [visibales removeObject:obj];
        obj.title = currentObj.title;
        currentObj.title = 0;
        [visibales addObject:currentObj];
    }
}


-(NSString*)getPlistPath
{
    //获取本地沙盒路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"MY_2048DataPropertyList.plist"];
    return plistPath;
    
}

-(void)saveData
{
    NSUserDefaults *defults = [NSUserDefaults standardUserDefaults];
    [defults setObject:@(score) forKey:@"score"];
    [defults setObject:@(bestScore) forKey:@"bestScore"];
    [defults setObject:@(targetScore) forKey:@"targetScore"];
    
    NSString * plistPath= [self getPlistPath];
    NSMutableData *data = [[NSMutableData alloc] init] ;
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data] ;
    [archiver encodeObject:dataArray forKey:@"my_2048DataList"];
    [archiver encodeObject:visibales forKey:@"my_visibales"];
    [archiver finishEncoding];
    [data writeToFile:plistPath atomically:YES];
}

-(void)getCacheData
{
    NSUserDefaults *defults = [NSUserDefaults standardUserDefaults];
    score = [[defults objectForKey:@"score"] integerValue];
    bestScore = [[defults objectForKey:@"bestScore"] integerValue];
    targetScore = [[defults objectForKey:@"targetScore"] integerValue];
    
    NSString * plistPath= [self getPlistPath];
    NSData * resultdata = [[NSData alloc] initWithContentsOfFile:plistPath];
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:resultdata];
    dataArray = [[unArchiver decodeObjectForKey:@"my_2048DataList"] mutableCopy];
    visibales = [unArchiver decodeObjectForKey:@"my_visibales"];
    [self configScore];
}

-(void)configScore
{
    [scoreLab setText:[NSString stringWithFormat:@"分数\n%ld",(long)score]];
    bestScore= score > bestScore?score:bestScore;
    [bestScoreLab setText:[NSString stringWithFormat:@"历史最高分数\n%ld",(long)bestScore]];
}

-(void)selectMenuBtn
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"回到上层菜单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"重新开始" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self reStart];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)reStart
{
    score = 0;
    [dataArray removeAllObjects];
    [visibales removeAllObjects];
    
    [self saveData];
    [self initData];
    [self configScore];
}

-(void)setLabText {
    scoreLab.text = [NSString stringWithFormat:@"分数\n%ld",(long)score];
    bestScoreLab.text = [NSString stringWithFormat:@"历史最高分数\n%ld",(long)bestScore];
}

@end
