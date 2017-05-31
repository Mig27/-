//
//  WPCompanyInforMationView.m
//  WP
//
//  Created by CBCCBC on 16/4/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPCompanyInforMationView.h"
#import "SPItemView.h"


typedef NS_ENUM(NSInteger,WPCompanyInforMationType) {
    WPRecruitControllerActionTypeCompanyName = 20/**< 公司名称 */,
    WPRecruitControllerActionTypeCompanyIndustry = 21/**< 公司行业 */,
    WPRecruitControllerActionTypeCompanyProperty = 22/**< 公司性质 */,
    WPRecruitControllerActionTypeCompanyScale = 23/**< 公司规模 */,
    WPRecruitControllerActionTypeCompanyArea = 24/**< 公司地点 */,
    WPRecruitControllerActionTypePersonalName = 25/**< 联系人 */,
//    WPRecruitControllerActionTypeCompanyPhone = 26/**< 联系方式 */,
    WPRecruitControllerActionTypeCompanyBrief = 26/**< 公司简介 */,
};
@implementation WPCompanyInforMationView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        NSArray *titleArr = @[@"*企业名称:",@"*企业行业:",@"*企业性质:",@"*企业规模:",@"*企业地点:",@"*联  系 人:",@"公司简介"];
        NSArray *placeHolderArr = @[@"请填写企业名称",@"请选择行业",@"请选择企业性质",@"请选择企业规模",@"请选择企业地点",@"请输入联系人",@"请输入公司简介"];
        NSArray *styleArr = @[kCellTypeText,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeText,kCellTypeButton];
        
//        UIView *lastview = nil;
        __weak typeof(self) weakSelf = self;
        for (int i = 0; i < titleArr.count; i++) {
            CGFloat top = frame.origin.y;
            SPItemView *item = [[SPItemView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, ItemViewHeight)];
            [item setTitle:titleArr[i] placeholder:placeHolderArr[i] style:styleArr[i]];
            item.tag = WPRecruitControllerActionTypeCompanyName+i;
            item.SPItemBlock = ^(NSInteger tag){
//                [weakSelf buttonItem:tag];
            };
            
            [self.items addObject:item];
            
            item.hideFromFont = ^(NSInteger tag, NSString *title){
                SPItemView *itemview = (SPItemView *)[weakSelf viewWithTag:tag];
                [itemview resetTitle:title];
                switch (tag) {
                    case WPRecruitControllerActionTypeCompanyName:
                        self.model.enterpriseName = title;
                        break;
                    case WPRecruitControllerActionTypePersonalName:
                        self.model.enterprisePersonName = title;
                        break;
                }
            };
        }

    }
            return self;
}

- (WPCompanyListModel *)upDateModel
{
    for (SPItemView *item in self.items) {
        if (item.tag == WPRecruitControllerActionTypeCompanyName) self.model.enterpriseName = item.textField.text;
        if (item.tag == WPRecruitControllerActionTypeCompanyIndustry) self.model.enterpriseName = item.textField.text;
        if (item.tag == WPRecruitControllerActionTypeCompanyProperty) self.model.enterpriseName = item.textField.text;
        if (item.tag == WPRecruitControllerActionTypeCompanyScale) self.model.enterpriseName = item.textField.text;
        if (item.tag == WPRecruitControllerActionTypeCompanyArea) self.model.enterpriseName = item.textField.text;
        if (item.tag == WPRecruitControllerActionTypePersonalName) self.model.enterpriseName = item.textField.text;
        if (item.tag == WPRecruitControllerActionTypeCompanyBrief) self.model.enterpriseName = item.textField.text;
    }
    return self.model;
}

- (NSMutableArray *)items
{
    if (!_items) {
        self.items = [NSMutableArray array];
    }
    return _items;
}


@end
