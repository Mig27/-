//
//  AnonymousModel.h
//  WP
//
//  Created by CBCCBC on 16/3/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseModel.h"
@class AnonymousModel;
@interface AnonymousListModel : BaseModel
@property (nonatomic ,strong)NSArray <AnonymousModel *>*list;
@end

@interface AnonymousModel : NSObject
@property (nonatomic, assign)BOOL selected;
@property (nonatomic, strong)NSString *anonyid;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *company;
@property (nonatomic, strong)NSString *postionName;
@property (nonatomic, strong)NSString *postionId;
@property (nonatomic ,strong)NSString *photo;
//@property (nonatomic, strong)NSString *avatar;
@property (nonatomic ,strong)NSString *is_default;
@property (nonatomic ,strong)UIImage *image;
@end
