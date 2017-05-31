//
//  WPIVModel.h
//  WP
//
//  Created by CBCCBC on 16/4/20.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseModel.h"
@class Dvlist;
@class Pohotolist;
@interface WPIVModel : BaseModel
@property (nonatomic ,strong)NSArray <Dvlist *>*VideoPhoto;
@property (nonatomic ,strong)NSArray <Pohotolist *>*ImgPhoto;
@end
