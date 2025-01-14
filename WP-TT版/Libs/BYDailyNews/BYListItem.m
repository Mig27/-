//
//  BYSelectionView.m
//  BYDailyNews
//
//  Created by bassamyan on 15/1/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BYListItem.h"

#define kDeleteW 6
#define kItemFont 12
#define kItemSizeChangeAdded 2

@implementation BYListItem

-(void)setItemName:(NSString *)itemName{
    _itemName = itemName;
    
    [self setTitle:itemName forState:0];
    [self setTitleColor:RGBColor(51, 51, 51) forState:0];
    self.titleLabel.font = [UIFont systemFontOfSize:kItemFont];
    self.layer.cornerRadius = 4;
    self.layer.borderColor = [RGBColor(200.0, 200.0, 200.0) CGColor];
    self.layer.borderWidth = 0.5;
    self.backgroundColor = [UIColor whiteColor];
    if (![itemName isEqualToString:@"全部"] && ![itemName isEqualToString:@"人气"]) {
        self.isNotAddDelet = NO;
    } else {
        self.isNotAddDelet = YES;
    }
//    [self addTarget:self
//             action:@selector(operationWithoutHidBtn)
//   forControlEvents:1<<6];
    
    self.gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pangestureOperation:)];
    self.longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    self.longGesture.minimumPressDuration = 1;
    self.longGesture.allowableMovement = 20;
    [self addGestureRecognizer:self.longGesture];
    
    if (!self.isNotAddDelet) {
        if (!self.deleteBtn) {
            self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(-kDeleteW+2, -kDeleteW+2, 2*kDeleteW, 2*kDeleteW)];
            self.deleteBtn.userInteractionEnabled = NO;
            [self.deleteBtn setImage:[UIImage imageNamed:@"delete.png"] forState:0];
            self.deleteBtn.layer.cornerRadius = self.deleteBtn.frame.size.width/2;
            self.deleteBtn.hidden = YES;
            self.deleteBtn.backgroundColor = RGBColor(111.0, 111.0, 111.0);
            [self addSubview:self.deleteBtn];
        }
    }
    if (!self.hiddenBtn) {
        self.hiddenBtn = [[UIButton alloc] initWithFrame:self.bounds];
        self.hiddenBtn.hidden = NO;
        [self.hiddenBtn addTarget:self
                           action:@selector(operationWithHidBtn)
                 forControlEvents:1 << 6];
        [self addSubview:self.hiddenBtn];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sortButtonClick)
                                                 name:@"sortBtnClick"
                                               object:nil];
}

-(void)longPress{
    if (self.hiddenBtn.hidden == NO) {
        if (self.longPressBlock) {
            self.longPressBlock();
        }
        if (self.location == top) {
            if (!self.isNotAddDelet) {
                [self addGestureRecognizer:self.gesture];
            }
        }
    }
}

-(void)sortButtonClick{

    if (self.location == top){
        self.deleteBtn.hidden = !self.deleteBtn.hidden;
    }
    self.hiddenBtn.hidden = !self.hiddenBtn.hidden;
    if (self.gestureRecognizers) {
        [self removeGestureRecognizer:self.gesture];
    }
    if (self.hiddenBtn.hidden && self.location == top) {
        if (!self.isNotAddDelet) {
            [self addGestureRecognizer:self.gesture];
        }
    }
    
}

-(void)operationWithHidBtn{

    if (!self.hiddenBtn.hidden) {
        if (self.location == top) {
            [self setTitleColor:[UIColor redColor] forState:0];
            if (self.operationBlock) {
                self.operationBlock(topViewClick,self.titleLabel.text,0);
            }
            [self animationForWholeView];
        }
        else if (self.location == bottom){
            [self changeFromBottomToTop];
        }
    }
}

-(void)operationWithoutHidBtn{

    if (self.location == top){
        [self changeFromTopToBottom];
    }
    else if (self.location == bottom) {
        self.deleteBtn.hidden = NO;
        [self addGestureRecognizer:self.gesture];
        [self changeFromBottomToTop];
    }
}

- (void)pangestureOperation:(UIPanGestureRecognizer *)pan{

    [self.superview exchangeSubviewAtIndex:[self.superview.subviews indexOfObject:self] withSubviewAtIndex:[[self.superview subviews] count] - 1];
    CGPoint translation = [pan translationInView:pan.view];
    CGPoint center = pan.view.center;
    center.x += translation.x;
    center.y += translation.y;
    pan.view.center = center;
    [pan setTranslation:CGPointZero inView:pan.view];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            CGRect itemFrame = self.frame;
            [self setFrame:CGRectMake(itemFrame.origin.x-kItemSizeChangeAdded, itemFrame.origin.y-kItemSizeChangeAdded, itemFrame.size.width+kItemSizeChangeAdded*2, itemFrame.size.height+kItemSizeChangeAdded*2)];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            BOOL InTopView = [self whetherInAreaWithArray:topView Point:center];
            if (InTopView) {
                NSInteger indexX = (center.x <= kItemW+2*padding2)? 0 : (center.x - kItemW-2*padding2)/(padding2+kItemW) + 1;
                NSInteger indexY = (center.y <= kItemH+2*padding2)? 0 : (center.y - kItemH-2*padding2)/(padding2+kItemH) + 1;
                
                NSInteger index = indexX + indexY*itemPerLine;
//                NSLog(@"******%d",index);
                index = (index == 0)? 1:index;
                [locateView removeObject:self];
                //等于人气时不能动不能动
                if (index == 1) {
                    [topView insertObject:self atIndex:index + 1];
                } else {
                    [topView insertObject:self atIndex:index];
                }
                locateView = topView;
                [self animationForTopView];
                if (self.operationBlock) {
                    self.operationBlock(FromTopToTop,self.titleLabel.text,(int)index);
                }
            }
            else if (!InTopView && center.y < [self TopViewMaxY]+50) {
                [locateView removeObject:self];
                [topView insertObject:self atIndex:topView.count];
                locateView = topView;
                [self animationForTopView];
                if (self.operationBlock) {
                    self.operationBlock(FromTopToTopLast,self.titleLabel.text,0);
                }
            }
            else if (center.y > [self TopViewMaxY]+50){
                [self changeFromTopToBottom];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
            [self animationForWholeView];
            break;
        default:
            break;
    }
}


-(void)changeFromTopToBottom{
    [locateView removeObject:self];
    [bottomView insertObject:self atIndex:0];
    locateView = bottomView;
    self.location = bottom;
    self.deleteBtn.hidden = YES;
    [self removeGestureRecognizer:self.gesture];
    if (self.operationBlock) {
        self.operationBlock(FromTopToBottomHead,self.titleLabel.text,0);
    }
    [self animationForWholeView];
}

-(void)changeFromBottomToTop{
    [locateView removeObject:self];
    [topView insertObject:self atIndex:topView.count];
    locateView = topView;
    self.location = top;
    if (self.operationBlock) {
        self.operationBlock(FromBottomToTopLast,self.titleLabel.text,0);
    }
    [self animationForWholeView];
}

- (BOOL)whetherInAreaWithArray:(NSMutableArray *)array Point:(CGPoint)point{
    int row = (array.count%itemPerLine == 0)? itemPerLine : array.count%itemPerLine;
    int column =  (int)(array.count-1)/itemPerLine+1;
    if ((point.x > 0 && point.x <=kScreenW &&point.y > 0 && point.y <= (kItemH + padding2)*(column-1)+padding2)||
        (point.x > 0 && point.x <= (row*(padding2+kItemW)+padding2)&& point.y > (kItemH + padding2)*(column -1)+padding2 && point.y <= (kItemH+padding2) * column+padding2)){
        return YES;
    }
    return NO;
}

- (unsigned long)TopViewMaxY{
    unsigned long y = 0;
    y = ((topView.count-1)/itemPerLine+1)*(kItemH + padding2) + padding2;
    y = SCREEN_HEIGHT - 100;
//    NSLog(@"^^^^^^^^^%d",y);
    return y;
}

- (void)animationForTopView{
    for (int i = 0; i < topView.count; i++){
        if ([topView objectAtIndex:i] != self){
            [self animationWithView:[topView objectAtIndex:i] frame:CGRectMake(padding2+(padding2+kItemW)*(i%itemPerLine), padding2+(kItemH + padding2)*(i/itemPerLine), kItemW, kItemH)];
        }
    }
}
-(void)animationForBottomView{
    for (int i = 0; i < bottomView.count; i++) {
        if ([bottomView objectAtIndex:i] != self) {
            [self animationWithView:[bottomView objectAtIndex:i] frame:CGRectMake(padding2+(padding2+kItemW)*(i%itemPerLine), [self TopViewMaxY]+50+(kItemH+padding2)*(i/itemPerLine), kItemW, kItemH)];
        }
    }
    [self animationWithView:self.hitTextLabel frame:CGRectMake(0,[self TopViewMaxY],kScreenW,30)];
}

- (void)animationForWholeView{
    for (int i = 0; i <topView.count; i++) {
        [self animationWithView:[topView objectAtIndex:i] frame:CGRectMake(padding2+(padding2+kItemW)*(i%itemPerLine), padding2+(padding2+kItemH)*(i/itemPerLine), kItemW, kItemH)];

    }
    for (int i = 0; i < bottomView.count; i++) {
        [self animationWithView:[bottomView objectAtIndex:i] frame:CGRectMake(padding2+(padding2+kItemW)*(i%itemPerLine), [self TopViewMaxY]+50+(kItemH+padding2)*(i/itemPerLine), kItemW, kItemH)];
    }
    [self animationWithView:self.hitTextLabel frame:CGRectMake(0,[self TopViewMaxY],kScreenW,30)];
}

-(void)animationWithView:(UIView *)view frame:(CGRect)frame{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [view setFrame:frame];
    } completion:^(BOOL finished){}];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
