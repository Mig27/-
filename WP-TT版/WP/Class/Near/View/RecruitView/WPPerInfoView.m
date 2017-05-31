//
//  WPPerInfoView.m
//  WP
//
//  Created by CBCCBC on 16/3/11.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPPerInfoView.h"
#import "SPItemView.h"

#import "WPRecruitApplyView.h"

#define KItemTag 20

@interface WPPerInfoView ()
@property (nonatomic ,strong)NSArray *titleArr;
@property (nonatomic ,strong)NSArray *typeArray;
@property (nonatomic ,strong)NSArray *placeholderArray;
@property (nonatomic ,strong)NSArray *keys;
@end

@implementation WPPerInfoView

- (instancetype)initWithTop:(CGFloat)top
{
    if ([super init]) {
        CGFloat height = 0;
        CGFloat H = 0;
        for (int i = 0; i < self.titleArr.count; i++) {
            
            if ((i == 9)||(i == 13)) {
                top += 8;
                H += 8;
            }
            
            SPItemView *view = [[SPItemView alloc] initWithFrame:CGRectMake(0, i * ItemViewHeight + H, SCREEN_WIDTH, ItemViewHeight)];
            [view setTitle:self.titleArr[i] placeholder:self.placeholderArray[i] style:self.typeArray[i]];
            
            view.tag = i + WPRecruitApplyViewActionTypeName;
            
            [self.viewArr addObject:view];
            [self addSubview:view];
            
            if (i == self.titleArr.count-1)
            {
                height = i * ItemViewHeight + H + ItemViewHeight;
            }
        }
        self.frame = CGRectMake(0 , top-8, SCREEN_WIDTH, height);
    }
    return self;
}

- (BOOL)couldnotCommitFrameBlock:(frameBlock)frameBloack
{
    BOOL commit = NO;
    for (SPItemView *view in self.viewArr) {
        if (view.tag == WPRecruitApplyViewActionTypeName) {
            [view textFieldIsnotNil];
            NSInteger length = view.textField.text.length;
            if (length > 4 || (length <= 1 && length>0)) {
                view.tipView.title = @"请填写2-4个汉子或字母";
                [view addSubview:view.tipView];
            }
            
        }
        if ([view textFieldIsnotNil]) {
            
            if (!commit) {
                frameBloack(view.frame);
            }
            
            commit = YES;
        }
    }
    return commit;
}

- (CGFloat)leftCorner
{
    if (!_leftCorner) {
        self.leftCorner = self.frame.origin.y + self.frame.size.height;
    }
    return _leftCorner;
}

- (NSArray *)titleArr
{
    if (!_titleArr) {
        //self.titleArr = @[@"姓       名:",@"性       别:",@"出生年月:",@"学       历:",@"户       籍:",@"工作年限:",@"现居住地:",@"手       机:",@"期望职位:",@"期望薪资:",@"期望福利:",@"期望地区:",@"个人亮点:",@"教育经历:",@"工作经历:",];
        
        self.titleArr = @[@"*姓       名:",@"*性       别:",@"*出生年月:",@"*学       历:",
                          @"*工作年限:",@"目前薪资:",@"婚姻状况:",@"户       籍:",@"现居住地:",
                          
                          @"*期望职位:",@"*期望薪资:",@"*期望地区:",@"期望福利:",
                          
                          @"个人亮点:",@"教育经历:",@"工作经历:",];
    }
    
    return _titleArr;
}

- (NSArray *)placeholderArray{
    if (!_placeholderArray) {
        //self.placeholderArray = @[@"请输入姓名",@"请选择性别",@"请选择出生年月",@"请选择学历",@"请选择户籍",@"请选择工作年限",@"请选择现居住地",@"请输入手机号码",@"请选择期望职位",@"请选择期望薪资",@"请选择期望福利",@"请选择期望地区",@"请输入个人亮点",@"请输入教育经历",@"请输入工作经历"];
        
        self.placeholderArray = @[@"2-4个汉子或字母",@"请选择性别",@"请选择出生年月",@"请选择学历",
                                  @"请选择工作年限",@"请选择目前薪资",@"请选择婚姻状况",@"请选择户籍",@"请选择现居住地",
                                  
                                  @"请选择期望职位",@"请选择期望薪资",@"请选择期望地区",@"请选择期望福利",
                                  
                                  @"请填写个人亮点",@"请填写教育经历",@"请填写工作经历"];
    }
    
    return _placeholderArray;
}

- (NSArray *)keys
{
    if (!_keys) {
        self.keys = @[@"name",@"sex",@"birthday",@"education",@"hometown",@"WorkTime",@"address",@"Tel",@"hopePosition",@"hopeSalary",@"hopeWelfare",@"hopeAddress",@"lightspot",@"",@"",@"",@""];
    }
    return _keys;
}

- (NSArray *)typeArray{
    if (!_typeArray) {
        self.typeArray = @[kCellTypeText,kCellTypeButton,kCellTypeButton,kCellTypeButton,
                           kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton,
                           
                           kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton,
                           
                           kCellTypeButton,kCellTypeButton,kCellTypeButton];
    }
    
    return _typeArray;
}

- (NSMutableArray *)viewArr
{
    if (!_viewArr) {
        self.viewArr = [NSMutableArray array];
    }
    return _viewArr;
}


@end
