//
//  WPResumeUserInfoModel.m
//  WP
//
//  Created by Kokia on 16/3/23.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPResumeUserInfoModel.h"

@implementation WPPathModel

@end

@implementation PhotoVideo

@end


@implementation Education

- (instancetype)init
{
    self = [super init ];
    
    if (self)
    {
        self.isSelected = NO;
        
        self.educationId = @"";
        self.beginTime = @"";
        self.endTime = @"";
        
        self.schoolName = @"";
        self.major = @"";
        self.education = @"";
        self.remark = @"";
        self.expList = [[NSArray alloc]init];
        
    }
    
    return self;
}


+ (NSDictionary *)objectClassInArray
{
    return @{@"expList":[WPPathModel class]};
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"educationId":@"education_id"};
}



@end

@implementation Work

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.isSelected = NO;
        
        self.workId = @"";
        self.beginTime = @"";
        self.endTime = @"";
        self.epName = @"";
        self.industryId = @"";
        self.industry = @"";
        self.epProperties = @"";
        self.department = @"";
        self.position = @"";
        self.positionId = @"";
        
        self.salary = @"";
        self.remark = @"";
        self.expList = [[NSArray alloc]init];
    }
    
    
    return self;
}


+ (NSDictionary *)objectClassInArray
{
    return @{@"expList":[WPPathModel class]};
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"workId":@"work_id",
             @"industryId":@"Industry_id",
             @"epProperties":@"ep_properties",
             @"positionId":@"position_id"};
}

@end

@implementation WPResumeUserInfoModel

//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"resumeUserId":@"resume_user_id",
//             @"workTime":@"WorkTime",
//             @"homeTownId":@"homeTown_id",
//             @"addressId":@"Address_id",
//             @"tel":@"Tel",
//             @"photoList":@"photoList",
//             @"videoList":@"videoList"
//             
//             };
//}
//
//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    return @{@"lightspotList":[WPPathModel class],
//             @"photoList" : [PhotoVideo class],
//             @"videoList" : [PhotoVideo class],
//             @"educationList" : [Education class],
//             @"workList" : [Work class] };
//}

+ (NSDictionary *)objectClassInArray{
    return @{//@"lightspotList":[WPPathModel class],
             @"photoList" : [PhotoVideo class],
             @"videoList" : [PhotoVideo class],
             @"educationList" : [Education class],
             @"workList" : [Work class] };
}

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"resumeUserId":@"resume_user_id",
             @"workTime":@"WorkTime",
             @"homeTownId":@"homeTown_id",
             @"addressId":@"Address_id",
             @"tel":@"Tel",
             @"photoList":@"photoList",
             @"videoList":@"videoList",
             @"hopeAddressID":@"Hope_addressID"
             };
}

// 需要初始化，不然WPRecruitApplyView里setListModel:会崩溃
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.resumeUserId = @"";
        self.name = @"";
        self.sex = @"";
        self.birthday = @"";
        self.education = @"";
        self.workTime = @"";
        self.homeTown = @"";
        self.homeTownId = @"";
        self.address = @"";
        self.addressId = @"";
        self.tel = @"";
        self.TelIsShow = @"1";
        self.lightspot = @"";
        self.nowSalary = @"";
        self.marriage = @"";
        self.webchat = @"";
        self.qq = @"";
        self.email = @"";
        
        self.info = @"";
        self.status = @"";
        
        self.Hope_Position = @"";
        self.Hope_salary = @"";
        self.Hope_address = @"";
        self.Hope_welfare = @"";
        self.hopePositionNo = @"";
        self.hopeAddressID = @"";
        
        self.draftCount = @"";
        self.resumeId = @"";
        
        self.resumeCount = @"";
    }
    
    return self;
}

- (NSString *)lightspotList
{
    if (!_lightspotList) {
        self.lightspotList = [NSString string];
    }
    return _lightspotList;
}

- (NSArray *)photoList
{
    if (!_photoList) {
        self.photoList = [NSArray array];
    }
    return _photoList;
}

- (NSArray *)videoList
{
    if (!_videoList) {
        self.videoList = [NSArray array];
    }
    return _videoList;
}

- (NSArray *)educationList
{
    if (!_educationList) {
        self.educationList = [NSArray array];
    }
    return _educationList;
}

- (NSArray *)workList
{
    if (!_workList) {
        self.workList = [NSArray array];
    }
    return _workList;
}


MJExtensionLogAllProperties

@end

@implementation WPResumeUserInfoListModel

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"resumeList" : [WPResumeUserInfoModel class]
             };
}

@end
