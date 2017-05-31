//
//  WPPositionListModel.h
//  WP
//
//  Created by CBCCBC on 16/3/30.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseModel.h"
@class WPPositionModel;
@interface WPPositionListModel : BaseModel
@property (nonatomic ,strong)NSArray <WPPositionModel *>*list;
@end

@interface WPPositionModel : NSObject
@property (nonatomic , strong)NSString *job_id;
@property (nonatomic , strong)NSString *enterprise_name;
@property (nonatomic , strong)NSString *logo;
@property (nonatomic , strong)NSString *jobPositon;
@property (nonatomic , strong)NSString *update_Time;
@property (nonatomic , strong)NSString *ep_id;
@end


