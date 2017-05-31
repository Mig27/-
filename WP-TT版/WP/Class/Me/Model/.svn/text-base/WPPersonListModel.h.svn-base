//
//  WPPersonListModel.h
//  WP
//
//  Created by CBCCBC on 16/3/30.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseModel.h"
//#import "DefaultParamsModel.h"
@class WPPersonModel;
@interface WPPersonListModel : BaseModel
@property (nonatomic ,strong)NSArray <WPPersonModel *>*resumeList;
@end

@class Videos;
@class Photos;
@interface WPPersonModel : NSObject
@property (nonatomic, assign)BOOL selected;
@property (nonatomic ,strong)NSString *sid;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,strong)NSString *sex;
@property (nonatomic ,strong)NSString *age;
@property (nonatomic ,strong)NSString *birthday;
@property (nonatomic ,strong)NSString *education;
@property (nonatomic ,strong)NSString *WorkTime;
@property (nonatomic ,strong)NSString *homeTown;
@property (nonatomic ,strong)NSString *homeTown_id;
@property (nonatomic ,strong)NSString *address;
@property (nonatomic ,strong)NSString *Address_id;
@property (nonatomic ,strong)NSString *Tel;
@property (nonatomic ,strong)NSString *workexperience;
@property (nonatomic ,strong)NSString *lightspot;
@property (nonatomic ,strong)NSString *user_avatar;
@property (nonatomic, strong)NSArray <Photos *>*PhotoList;
@property (nonatomic, strong)NSArray <Videos *>*VideoList;
@end

@interface Photos : NSObject
@property (nonatomic ,strong)NSString *thumb_path;
@property (nonatomic ,strong)NSString *original_path;
@end

@interface Videos : NSObject
@property (nonatomic ,strong)NSString *thumb_path;
@property (nonatomic ,strong)NSString *original_path;
@end

