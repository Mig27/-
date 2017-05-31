//
//  WPRecruitApplyChooseDetailModel.m
//  WP
//
//  Created by CBCCBC on 15/11/9.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPRecruitApplyChooseDetailModel.h"

@implementation WPRecruitApplyChooseDetailModel

- (id)init{
    self = [super init];
    if (self) {
        self.education = @"";
        self.lightspot = @"";
        self.birthday = @"";
        self.webchat = @"";
        self.draftCount = @"";
        self.resumeId = @"";
        self.workTime = @"";
        self.sex = @"";
        self.tel = @"";
        self.resumeCount = @"";
        self.status = @"";
        self.nowSalary = @"";
        self.HopeSalary = @"";
        self.HopeAddress = @"";
        self.name = @"";
        self.info = @"";
        self.homeTownId = @"";
        self.resumeUserId = @"";
        self.hopePositionNo = @"";
        self.email = @"";
        self.hopeAddressID = @"";
        self.marriage = @"";
        self.homeTown = @"";
        self.qq = @"";
        self.addressId = @"";
        self.hopePosition = @"";
        self.address = @"";
        self.hopeWelfare = @"";
        self.photoList = [[NSArray alloc]init];
        self.videoList = [[NSArray alloc]init];
        self.workList = [[NSArray alloc]init];
        self.educationList = [[NSArray alloc]init];
    }
    return self;
}

+ (NSDictionary *)objectClassInArray{
    return @{@"videoList" : [Dvlist class], @"workList" : [Worklist class], @"educationList" : [Educationlist class], @"photoList" : [Pohotolist class],@"lightspotList":[WPRemarkModel class]};
}

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"resumeId":@"resume_id",
             @"workTime":@"WorkTime",
             @"tel":@"Tel",
             @"HopeSalary":@"Hope_salary",
             @"HopeAddress":@"Hope_address",
             @"homeTownId":@"homeTown_id",
             @"resumeUserId":@"resume_user_id",
             @"hopePositionNo":@"Hope_PositionNo",
             @"hopeAddressID":@"Hope_addressID",
             @"addressId":@"Address_id",
             @"hopePosition":@"Hope_Position",
             @"hopeWelfare":@"Hope_welfare",};
}

@end