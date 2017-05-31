//
//  WPNewPositionModel.h
//  WP
//
//  Created by Kokia on 16/5/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPNewPositionModel : NSObject

@property (copy, nonatomic) NSString *positionID; //职位ID
@property (copy, nonatomic) NSString *industryID;
@property (copy, nonatomic) NSString *fatherID;
@property (copy, nonatomic) NSString *positionName;
@property (copy, nonatomic) NSString *industryName;

@property (copy, nonatomic) NSString *sex;
@property (assign, nonatomic) NSInteger section;
@property (assign, nonatomic) NSInteger row;

@end
