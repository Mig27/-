//
//  SPLocalApplyArray.m
//  WP
//
//  Created by CBCCBC on 15/11/25.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "SPLocalApplyArray.h"
#import "IndustryModel.h"
#import "WPShuoStaticData.h"
@implementation SPLocalApplyArray

+ (NSArray *)sexWithNoLimitArray{
    NSMutableArray *educationArr = [[NSMutableArray alloc]init];
    NSArray *Education = @[@"不限",@"男",@"女"];
    for (int i = 0; i < Education.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = Education[i];
        model.industryID = [NSString stringWithFormat:@"%d",i+1];
        [educationArr addObject:model];
    }
    return educationArr;
}

+ (NSArray *)sexArray{
    NSMutableArray *educationArr = [[NSMutableArray alloc]init];
    NSArray *Education = @[@"男",@"女"];
    for (int i = 0; i < Education.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = Education[i];
        model.industryID = [NSString stringWithFormat:@"%d",i+1];
        [educationArr addObject:model];
    }
    return educationArr;
}

+ (NSArray *)ageArray{
    NSMutableArray *educationArr = [[NSMutableArray alloc]init];
    NSArray *Education = @[@"不限",@"16-20岁",@"21-25岁",@"26-30岁",@"31-40岁",@"40岁以上"];
    for (int i = 0; i < Education.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = Education[i];
        model.industryID = [NSString stringWithFormat:@"%d",i+1];
        [educationArr addObject:model];
    }
    return educationArr;
}

+ (NSArray *)educationArray{
    NSMutableArray *educationArr = [[NSMutableArray alloc]init];
    NSArray *Education = @[@"不限",@"初中及以下",@"高中",@"技校",@"中专",@"大专",@"本科",@"硕士",@"博士"];
    for (int i = 0; i < Education.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = Education[i];
        [educationArr addObject:model];
    }
    return educationArr;
}
+(NSArray*)noLimitEducationArray
{
    NSMutableArray *educationArr = [[NSMutableArray alloc]init];
    NSArray *Education = @[@"高中及以下",@"技校",@"中专",@"大专",@"本科",@"硕士",@"博士"];
    for (int i = 0; i < Education.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = Education[i];
        [educationArr addObject:model];
    }
    return educationArr;
}

+ (NSArray *)salaryArray{
    NSArray *wage = @[@"不限",@"面议",@"1000元以下",@"1000-2000元",@"2000-3000元",@"3000-5000元",@"5000-8000元",@"8000-12000元",@"12000-20000元",@"20000元以上"];
    NSMutableArray *wageArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < wage.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = wage[i];
        model.industryID = [NSString stringWithFormat:@"%d",i];
        [wageArr addObject:model];
    }
    return wageArr;
}

+ (NSArray *)marriageArray{
    NSArray *wage = @[@"已婚",@"未婚",@"保密"];
    NSMutableArray *wageArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < wage.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = wage[i];
        model.industryID = [NSString stringWithFormat:@"%d",i+1];
        [wageArr addObject:model];
    }
    return wageArr;
}

+ (NSArray *)workTimeArray{
    NSMutableArray *experienceArr = [[NSMutableArray alloc]init];
     NSArray *experience = @[@"不限",@"一年以下",@"1-2年",@"3-5年",@"6-8年",@"8-10年",@"10年以上"];
    for (int i = 0; i < experience.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = experience[i];
        model.industryID = [NSString stringWithFormat:@"%d",i+1];
        [experienceArr addObject:model];
    }
    return experienceArr;
}

+ (NSArray *)unLimitWelfareArray{
     WPShuoStaticData * shuoData = [WPShuoStaticData shareShuoData];
    NSArray * idArray = [shuoData.welfareID componentsSeparatedByString:@","];
    
    NSArray *Welfare = @[@"不限",@"五险一金",@"包吃包住",@"年底双薪",@"周末双休",@"交通补助",@"加班补助"];
    NSMutableArray *WelfareArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < Welfare.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = Welfare[i];
        model.industryID = [NSString stringWithFormat:@"%d",i+1];
        for (NSString * string in idArray) {
            if ([model.industryID isEqualToString:string]) {
                model.isSelected  = YES;
            }
        }
        [WelfareArr addObject:model];
        
    }
    return WelfareArr;
}

+ (NSArray *)welfareArray{
    NSArray *Welfare = @[@"五险一金",@"包吃包住",@"年底双薪",@"周末双休",@"交通补助",@"加班补助"];
    NSMutableArray *WelfareArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < Welfare.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = Welfare[i];
        model.industryID = [NSString stringWithFormat:@"%d",i+1];
        [WelfareArr addObject:model];
    }
    return WelfareArr;
}

+ (NSArray *)natureArray{
    NSArray *nature = @[@"个人企业",@"非盈利机构",@"政府机关",@"事业单位",@"上市公司",@"中外合资/合作",@"外商独资/办事处"];
    NSMutableArray *natureArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < nature.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = nature[i];
        model.industryID = [NSString stringWithFormat:@"%d",i+1];
        [natureArr addObject:model];
    }
    return natureArr;
}

+ (NSArray *)scaleArray{
    NSArray *scale = @[@"1-49人",@"50-99人",@"100-499人",@"500-999人",@"1000以上"];
    NSMutableArray *scaleArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < scale.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = scale[i];
        model.industryID = [NSString stringWithFormat:@"%d",i+1];
        [scaleArr addObject:model];
    }
    return scaleArr;
}

+ (NSArray *)interviewApplyArray{
    NSArray *condition = @[@"联系人",@"联系方式",@"企业信息",@"招聘职位",@"招聘行业",@"工资待遇",@"企业福利",@"工作年限",@"学历要求",@"性别要求",@"年龄要求",@"招聘人数",@"工作地点",@"任职要求"];
    NSMutableArray *conditionArr = [[NSMutableArray alloc]init];for (int i = 0; i < condition.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = condition[i];
        model.industryID = [NSString stringWithFormat:@"%d",i+1];
        [conditionArr addObject:model];
    }
    return conditionArr;
}

+(NSString *)sexToString:(id)sex{
    if ([sex isKindOfClass:[NSString class]]) {
        if ([sex isEqualToString:@"男"]) {
            return @"男";
        }
        else if ([sex isEqualToString:@"女"]) {
            return @"女";
        }
        else if ([sex isEqualToString:@"1"]) {
            return @"男";
        }
        else{
            return @"女";
        }
    }else{
        if ((int)sex == 1) {
            return @"男";
        }else{
            return @"女";
        }
    }
}

+(NSString *)sexToNumber:(id)sex{
    if ([sex isKindOfClass:[NSString class]]) {
        if ([sex isEqualToString:@"男"]) {
            return @"1";
        }
        else if ([sex isEqualToString:@"女"]) {
            return @"0";
        }
        else if ([sex isEqualToString:@"1"]) {
            return @"1";
        }
        else{
            return @"0";
        }
    }else{
        if ((int)sex == 1) {
            return @"1";
        }else{
            return @"0";
        }
    }
}

@end
