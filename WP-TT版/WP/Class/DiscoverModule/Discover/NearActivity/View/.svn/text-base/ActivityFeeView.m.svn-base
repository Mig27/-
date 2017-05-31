//
//  ActivityFeeView.m
//  WP
//
//  Created by 沈亮亮 on 15/10/20.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "ActivityFeeView.h"
#import "SPItemView.h"


#define ItemCount 10

@interface ActivityFeeView ()

@property (nonatomic,assign) NSInteger number;

@end

@implementation ActivityFeeView

- (void)setNumber:(NSInteger)number
{
    self.tag = number;
    _number = number;
    NSArray *title = @[@"费用名称",@"需付金额",@"名额限制"];
    NSArray *placehoder = @[@"请输入费用名称",@"默认免费",@"默认无限制"];
    NSArray *style = @[kCellTypeText,kCellTypeText,kCellTypeText];
    for (int i=0; i<title.count; i++) {
        SPItemView *item = [[SPItemView alloc] initWithFrame:CGRectMake(0, (kHEIGHT(43) + 0.5)*i, SCREEN_WIDTH, kHEIGHT(43))];
        [item setTitle:title[i] placeholder:placehoder[i] style:style[i]];
        item.tag = 100 + number*ItemCount + i;
        if (i == 0) {
            self.name = item;
        } else if (i == 1) {
            self.money = item;
            self.money.textField.keyboardType = UIKeyboardTypeNumberPad;
        } else if (i == 2) {
            self.num = item;
            self.num.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
//        item.hideFromFont = ^(NSInteger tag, NSString *title){
//            NSInteger index = tag - number*ItemCount - 100;
//            if (index == 0) {
//                NSLog(@"费用名称");
//            } else if (index == 1) {
//                NSLog(@"需付金额");
//            } else if (index == 2) {
//                NSLog(@"名额限制");
//            }
//        };
        
        [self addSubview:item];
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, (kHEIGHT(43) + 0.5)*3, SCREEN_WIDTH, kHEIGHT(43))];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(43));
    [button setImage:[UIImage imageNamed:@"fee_add"] forState:UIControlStateNormal];
    [button setTitle:@" 添加费用项" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = kFONT(15);
    [button addTarget:self action:@selector(addMorePosition:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(button.width/2-52.5-10, 0, 105, 43)];
//    label.text = @"添加费用项";
//    label.font = GetFont(15);
//    [button addSubview:label];
//    
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(label.right+6, 15.5, 14, 12)];
//    imageView.image = [UIImage imageNamed:@"qiehuanjiantou"];
//    [button addSubview:imageView];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteBtn.frame = CGRectMake(SCREEN_WIDTH - 26, 4, 22, 22);
    [self.deleteBtn addTarget:self action:@selector(deletePosition) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn setImage:[UIImage imageNamed:@"near_act_delect"] forState:UIControlStateNormal];
    [self addSubview:self.deleteBtn];

}

- (void)setNumber:(NSInteger)number andModel:(FeeModel *)model
{
//    NSLog(@"******%@******%@*****%@",model.name,model.money,model.num);
    self.tag = number;
    _number = number;
    NSArray *title = @[@"费用名称",@"需付金额",@"名额限制"];
    NSArray *placehoder = @[@"请输入费用名称",@"默认免费",@"默认无限制"];
    NSArray *style = @[kCellTypeText,kCellTypeText,kCellTypeText];
    for (int i=0; i<title.count; i++) {
        SPItemView *item = [[SPItemView alloc] initWithFrame:CGRectMake(0, (kHEIGHT(43) + 0.5)*i, SCREEN_WIDTH, kHEIGHT(43))];
        [item setTitle:title[i] placeholder:placehoder[i] style:style[i]];
        item.tag = 100 + number*ItemCount + i;
        if (i == 0) {
            self.name = item;
            self.name.textField.text = model.name;
        } else if (i == 1) {
            self.money = item;
            self.money.textField.keyboardType = UIKeyboardTypeNumberPad;
            self.money.textField.text = model.money;
        } else if (i == 2) {
            self.num = item;
            self.num.textField.keyboardType = UIKeyboardTypeNumberPad;
            self.num.textField.text = model.num;
        }
        //        item.hideFromFont = ^(NSInteger tag, NSString *title){
        //            NSInteger index = tag - number*ItemCount - 100;
        //            if (index == 0) {
        //                NSLog(@"费用名称");
        //            } else if (index == 1) {
        //                NSLog(@"需付金额");
        //            } else if (index == 2) {
        //                NSLog(@"名额限制");
        //            }
        //        };
        
        [self addSubview:item];
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, (kHEIGHT(43) + 0.5)*3, SCREEN_WIDTH, kHEIGHT(43))];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(43));
    [button setImage:[UIImage imageNamed:@"fee_add"] forState:UIControlStateNormal];
    [button setTitle:@" 添加费用项" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = kFONT(15);
    [button addTarget:self action:@selector(addMorePosition:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    //    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(button.width/2-52.5-10, 0, 105, 43)];
    //    label.text = @"添加费用项";
    //    label.font = GetFont(15);
    //    [button addSubview:label];
    //
    //    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(label.right+6, 15.5, 14, 12)];
    //    imageView.image = [UIImage imageNamed:@"qiehuanjiantou"];
    //    [button addSubview:imageView];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteBtn.frame = CGRectMake(SCREEN_WIDTH - 26, 4, 22, 22);
    [self.deleteBtn addTarget:self action:@selector(deletePosition) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn setImage:[UIImage imageNamed:@"near_act_delect"] forState:UIControlStateNormal];
    [self addSubview:self.deleteBtn];

}

- (void)deletePosition
{
    if (self.deleteItem) {
        self.deleteItem(self.tag);
    }
//    [self removeFromSuperview];
}

- (void)addMorePosition:(UIButton *)sender
{
    NSLog(@"添加");
    if (self.addMoreItem) {
        self.addMoreItem(self.tag);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
