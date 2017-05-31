//
//  DemandListModel.h
//  WP
//
//  Created by 沈亮亮 on 15/9/28.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "BaseModel.h"

@interface DemandListModel : BaseModel

@property (nonatomic,copy) NSArray *Photo;        //照片
@property (nonatomic,copy) NSString *avatar;      //头像
@property (nonatomic,copy) NSString *userName;    //用户名
@property (nonatomic,copy) NSString *userPostion; //用户的职位
@property (nonatomic,copy) NSString *userCompany; //用户的公司
@property (nonatomic,copy) NSString *addTime;     //说说发布时间
@property (nonatomic,copy) NSArray *Info;         //招聘的信息
@property (nonatomic,copy) NSString *address;     //发布的位置
@property (nonatomic,copy) NSString *commentCount;//评论人数
@property (nonatomic,copy) NSString *entryCount;  //报名人数
@property (nonatomic,copy) NSString *isAttent;    //是否已关注
@property (nonatomic,copy) NSString *isMyself;    //是否是自己发布的
@property (nonatomic,copy) NSString *isEntry;     //是否已报名

@end

@interface DemandModel : BaseModel

@property (strong, nonatomic) NSArray *list;
@property (assign, nonatomic) NSInteger PageIndex;

@end
