//
//  BYConditionBar.m
//  BYDailyNews
//
//  Created by bassamyan on 15/1/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BYListBar.h"
#import "BYArrow.h"
#import "BYArrowInfo.h"

#define kDistanceBetweenItem 21
#define kExtraPadding 20
#define itemFont 13

@interface BYListBar()

@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, strong) UIView *btnBackView;
@property (nonatomic, strong) UIButton *btnSelect;
@property (nonatomic, strong) BYArrow *arrow;



@end

@implementation BYListBar

-(NSMutableArray *)btnLists{
    if (_btnLists == nil) {
        _btnLists = [NSMutableArray array];
    }
    return _btnLists;
}

-(void)setVisibleItemList:(NSMutableArray *)visibleItemList{
    
    _visibleItemList = visibleItemList;
    
    if (!self.btnBackView) {
        self.btnBackView = [[UIView alloc] initWithFrame:CGRectMake(10,(self.frame.size.height-20)/2,46,20)];
        //self.btnBackView.backgroundColor = RGBColor(202.0, 51.0, 54.0);
        self.btnBackView.backgroundColor = [UIColor clearColor];
        self.btnBackView.layer.cornerRadius = 5;
        [self addSubview:self.btnBackView];
        
        self.maxWidth = 10;
        //self.backgroundColor = RGBColor(238.0, 238.0, 238.0);
        self.backgroundColor = [UIColor whiteColor];
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 50);
        self.showsHorizontalScrollIndicator = NO;
        for (int i =0; i<visibleItemList.count; i++) {
            [self makeItemWithTitle:visibleItemList[i]];
        }
        self.contentSize = CGSizeMake(self.maxWidth, self.frame.size.height);
    }
}


-(void)makeItemWithTitle:(NSString *)title{
    CGFloat itemW = [self calculateSizeWithFont:itemFont Text:title].size.width;
    UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(self.maxWidth, 0, itemW, self.frame.size.height)];
    item.titleLabel.font = [UIFont systemFontOfSize:itemFont];
    [item setTitle:title forState:0];
    [item setTitleColor:RGBColor(51, 51, 51) forState:0];
    [item setTitleColor:RGBColor(51, 51, 51) forState:1<<0];
//    [item setTitleColor:[UIColor whiteColor] forState:1<<2];
    [item setTitleColor:RGBColor(51, 51, 51) forState:1<<2];

    
    [item addTarget:self
             action:@selector(itemClick:)
   forControlEvents:1 << 6];
    self.maxWidth += itemW+kDistanceBetweenItem;
    [self.btnLists addObject:item];
    [self addSubview:item];
    if (!self.btnSelect) {
        [item setTitleColor:[UIColor redColor] forState:0];
        self.btnSelect = item;
    }
    self.contentSize = CGSizeMake(self.maxWidth, self.frame.size.height);
}


-(void)itemClick:(UIButton *)sender{
    if (self.btnSelect != sender) {
        [self.btnSelect setTitleColor:RGBColor(51, 51, 51) forState:0];
        //[sender setTitleColor:[UIColor whiteColor] forState:0];
        [sender setTitleColor:[UIColor redColor] forState:0];

        self.btnSelect = sender;
        
        if (self.listBarItemClickBlock) {
            self.listBarItemClickBlock(sender.titleLabel.text,[self findIndexOfListsWithTitle:sender.titleLabel.text]);
        }
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect btnBackViewRect = self.btnBackView.frame;
        btnBackViewRect.size.width = sender.frame.size.width+kExtraPadding;
        self.btnBackView.frame = btnBackViewRect;
        CGFloat changeW = sender.frame.origin.x-(btnBackViewRect.size.width-sender.frame.size.width)/2-10;
        self.btnBackView.transform  = CGAffineTransformMakeTranslation(changeW, 0);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint changePoint;

            if (sender.frame.origin.x >self.frame.size.width/2 && sender.frame.origin.x < self.contentSize.width-self.frame.size.width/2)/**< 大于半个屏幕宽度，小于滚动宽度和半个屏幕差 */
            {
                changePoint = CGPointMake(sender.frame.origin.x - self.frame.size.width/2, 0);
            }
            else if (sender.frame.origin.x > self.contentSize.width-self.frame.size.width/2)/**< 大于滚动宽度和半个屏幕差，小于滚动宽度 */
            {
                changePoint = CGPointMake(self.contentSize.width-self.frame.size.width+kDistanceBetweenItem, 0);
            }
            else{/**< 小于半个屏幕宽度 */
                changePoint = CGPointMake(0, 0);
            }
            self.contentOffset = changePoint;
        }];
    }];
}

-(void)itemClickByScrollerWithIndex:(NSInteger)index{
    UIButton *item = (UIButton *)self.btnLists[index];
    [self itemClick:item];
}

-(void)operationFromBlock:(animateType)type itemName:(NSString *)itemName index:(int)index{
    switch (type) {
        case topViewClick:
            [self itemClick:self.btnLists[[self findIndexOfListsWithTitle:itemName]]];
            if (self.arrowChange) {

//                BYArrowInfo *p = [BYArrowInfo defaultInfo];
//                
//                
//                _arrow.backgroundColor = [UIColor redColor];
//
//                p.one++;


                self.arrowChange();
            }
            break;
        case FromTopToTop:
            [self switchPositionWithItemName:itemName index:index];
            break;
        case FromTopToTopLast:
            [self switchPositionWithItemName:itemName index:self.visibleItemList.count-1];
            break;
        case FromTopToBottomHead:
            if ([self.btnSelect.titleLabel.text isEqualToString:itemName]) {
                [self itemClick:self.btnLists[0]];
            }
            [self removeItemWithTitle:itemName];
            [self resetFrame];
            break;
        case FromBottomToTopLast:
            [self.visibleItemList addObject:itemName];
            [self makeItemWithTitle:itemName];
            break;
        default:
            break;
    }
}

-(void)switchPositionWithItemName:(NSString *)itemName index:(NSInteger)index{
    UIButton *button = self.btnLists[[self findIndexOfListsWithTitle:itemName]];
    [self.visibleItemList removeObject:itemName];
    [self.btnLists removeObject:button];
    [self.visibleItemList insertObject:itemName atIndex:index];
    [self.btnLists insertObject:button atIndex:index];
    [self itemClick:self.btnSelect];
    [self resetFrame];
}

-(void)removeItemWithTitle:(NSString *)title{
    NSInteger index = [self findIndexOfListsWithTitle:title];
    UIButton *select_button = self.btnLists[index];
    [self.btnLists[index] removeFromSuperview];
    [self.btnLists removeObject:select_button];
    [self.visibleItemList removeObject:title];
}

-(NSInteger)findIndexOfListsWithTitle:(NSString *)title{
    for (int i =0; i < self.visibleItemList.count; i++) {
        if ([title isEqualToString:self.visibleItemList[i]]) {
            return i;
        }
    }
    return 0;
}

-(void)resetFrame{
    self.maxWidth = 20;
    for (int i = 0; i < self.visibleItemList.count; i++) {
        [UIView animateWithDuration:0.0001 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            CGFloat itemW = [self calculateSizeWithFont:itemFont Text:self.visibleItemList[i]].size.width;
            [[self.btnLists objectAtIndex:i] setFrame:CGRectMake(self.maxWidth, 0, itemW, self.frame.size.height)];
            self.maxWidth += kDistanceBetweenItem + itemW;
        } completion:^(BOOL finished){
        }];
    }
    self.contentSize = CGSizeMake(self.maxWidth, self.frame.size.height);
}

-(CGRect)calculateSizeWithFont:(NSInteger)Font Text:(NSString *)Text{
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:Font]};
    CGRect size = [Text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                     options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attr
                                     context:nil];
    return size;
}

@end
