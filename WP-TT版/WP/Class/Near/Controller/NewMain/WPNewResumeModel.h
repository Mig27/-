//
//  WPNewResumeModel.h
//  WP
//
//  Created by CBCCBC on 16/1/25.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseModel.h"
#import "WPNewResumeController.h"

@interface WPNewResumeModel : BaseModel

@property (strong, nonatomic) NSArray *list;
@property (assign, nonatomic) NSInteger PageIndex;
@property (copy,nonatomic)NSString * company;
@property (copy,nonatomic)NSString * nick_name;
@property (copy,nonatomic)NSString *avatar;
@property (copy, nonatomic)NSString *position;

@end

@interface WPNewResumeListModel : BaseModel

#pragma mark - 通用
@property (assign, nonatomic) BOOL isSelected;
@property (assign, nonatomic) WPMainPositionType type;
@property (copy, nonatomic) NSString *updateTime;
@property (assign,nonatomic)NSUInteger timeOrder;
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *resumeId;
@property (copy, nonatomic)NSString *resume_user_id;
@property (copy, nonatomic)NSString * guid;
@property (copy, nonatomic)NSString * time;

#pragma mark - 求职
@property (copy, nonatomic) NSString *HopePosition;
@property (copy, nonatomic) NSString *position;
@property (copy, nonatomic) NSString *WorkTim;
@property (copy, nonatomic) NSString *worktime;
@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *birthday;
@property (copy, nonatomic) NSString *education;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *sex;
@property (copy, nonatomic) NSString *nike_name;
@property (copy, nonatomic) NSString *age;
@property (copy, nonatomic) NSString *lightspot;

#pragma mark - 招聘
@property (copy, nonatomic) NSString *enterpriseName;
@property (copy, nonatomic) NSString *epId;
@property (copy, nonatomic) NSString *jobPositon;
@property (copy, nonatomic) NSString *logo;
@property (copy, nonatomic) NSString *enterprise_properties;//性质
@property (copy, nonatomic) NSString *dataIndustry;//行业
@property (copy, nonatomic) NSString *enterprise_scale;//规模
@property (copy, nonatomic) NSString *enterprise_address;
@property (copy, nonatomic) NSString *enterprise_brief;

@property (copy, nonatomic) NSString *txtcontent;

@end
